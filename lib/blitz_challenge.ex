defmodule BlitzChallenge do
  use GenServer

  alias BlitzChallenge.Summoner.MatchMonitorWorker
  alias BlitzChallenge.Summoner

  defstruct user: %{summoner_name: nil, puuid: nil},
            region: nil,
            subdomain: nil,
            recent_summoners: nil

  @one_hour_in_ms :timer.hours(1)

  # Client Functions
  def fetch_recent_summoners, do: GenServer.call(__MODULE__, :fetch_recent_summoners)

  def get_subdomain, do: GenServer.call(__MODULE__, :get_subdomain)

  def request_user_input, do: GenServer.call(__MODULE__, :request_user_input)

  def set_user_puuid(puuid), do: GenServer.cast(__MODULE__, {:set_puuid, puuid})

  def set_subdomain(subdomain), do: GenServer.cast(__MODULE__, {:set_subdomain, subdomain})

  # Server Functions
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state, {:continue, :request_user_input}}
  end

  @impl true
  def handle_call(:fetch_active_participants, _ref, state) do
    {:reply, state.recent_summoners, state}
  end

  @impl true
  def handle_call(:get_subdomain, _ref, state) do
    {:reply, state.subdomain, state}
  end

  @impl true
  def handle_continue(:request_user_input, _state) do
    user_input = console_input_module().request_all_user_input()

    state =
      %__MODULE__{
        user: %{summoner_name: user_input[:summoner_name], puuid: nil},
        region: user_input[:region],
        subdomain: user_input[:subdomain],
        recent_summoners: nil
      }

    Process.send(self(), :fetch_and_monitor_recent_summoners, [])
    {:noreply, state}
  end

  @impl true
  def handle_info(:fetch_and_monitor_recent_summoners, state) do
    {:ok, summoner_list} = Summoner.fetch_recent_summoners(Map.from_struct(state))
    :ok = Summoner.print_recent_player_list(summoner_list)
    Enum.each(summoner_list, &add_match_monitor_for_summoner(&1, state.region))

    IO.puts("Monitoring all recent summoner matches")

    Process.send_after(self(), :stop, @one_hour_in_ms)

    {:noreply, %{state | recent_summoners: summoner_list}}
  end

  @impl true
  def handle_info(:stop, state) do
    IO.puts("\n\n Time is up! Restarting. \n\n")

    {:stop, :normal, state}
  end

  @impl true
  def handle_cast({:set_subdomain, subdomain}, state) do
    {:noreply, %{state | subdomain: subdomain}}
  end

  @impl true
  def handle_cast({:set_puuid, puuid}, state) do
    {:noreply, %{state | user: Map.merge(state.user, %{puuid: puuid})}}
  end

  defp add_match_monitor_for_summoner(summoner, region) do
    %{summoner_name: summoner_name, puuid: puuid, match_id: match_id} = summoner
    MatchMonitorWorker.new(summoner_name, puuid, region, match_id)
  end

  # Config

  defp console_input_module do
    Application.get_env(:blitz_challenge, :modules)[:console_input_module]
  end
end
