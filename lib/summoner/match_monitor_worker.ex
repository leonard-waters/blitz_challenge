defmodule BlitzChallenge.Summoner.MatchMonitorWorker do
  use GenServer

  alias BlitzChallenge.Summoner.MatchMonitorSupervisor

  @minute_in_ms :timer.minutes(1)

  defstruct puuid: nil,
            summoner_name: nil,
            region: nil,
            recent_match_ids: []

  def new(summoner_name, puuid, region, last_match_id) do
    args = %{
      summoner_name: summoner_name,
      puuid: puuid,
      region: region,
      last_match_id: last_match_id
    }

    DynamicSupervisor.start_child(MatchMonitorSupervisor, {__MODULE__, args})
  end

  def stop(pid) do
    DynamicSupervisor.terminate_child(MatchMonitorSupervisor, pid)
  end

  def fetch_monitor_info do
    DynamicSupervisor.count_children(MatchMonitorSupervisor)
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: args.puuid)
  end

  @impl true
  def init(args) do
    state = %__MODULE__{
      puuid: args.puuid,
      summoner_name: args.summoner_name,
      region: args.region,
      recent_match_ids: [args.last_match_id]
    }

    {:ok, state, {:continue, :schedule_recheck}}
  end

  @impl GenServer
  def handle_info(:check_new_matches, state) do
    # TODO: Should move the logic out into a client module to more easily test
    updated_state =
      case match_module().check_new_matches(state.puuid, state.region, state.recent_match_ids) do
        {:ok, new_match_ids} ->
          Enum.each(new_match_ids, fn match_id ->
            IO.puts("Summoner #{state.summoner_name} completed match: #{match_id} ")
          end)

          update_in(state, [:recent_match_ids], state.recent_match_ids ++ new_match_ids)

        _ ->
          state
      end

    schedule_recheck()

    {:noreply, updated_state}
  end

  @impl GenServer
  def handle_continue(:schedule_recheck, state) do
    schedule_recheck()
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(:stop_tracking, state) do
    {:stop, :normal, state}
  end

  # Private functions
  defp schedule_recheck do
    Process.send_after(self(), :recheck, @minute_in_ms)
  end

  # Config

  defp match_module do
    Application.get_env(:blitz_challenge, :modules)[:match_module]
  end
end
