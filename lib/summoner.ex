defmodule BlitzChallenge.Summoner do
  @moduledoc false
  alias BlitzChallenge.ConsoleMessage
  alias BlitzChallenge.RiotAPI.Util

  @callback fetch_recent_summoners(map()) :: {:ok, list()} | {:error, any()}

  def fetch_recent_summoners(%{user: %{puuid: nil}, subdomain: nil, region: region} = state) do
    with {:ok, puuid} <- fetch_summoner_puuid_by_region(state.user.summoner_name, region),
         {:ok, recent_summoners} <- do_fetch_recent_summoners(puuid, region) do
      {:ok, recent_summoners}
    else
      {:error, error} -> {:error, error}
    end
  end

  def fetch_recent_summoners(%{user: %{puuid: nil}, subdomain: subdomain, region: region} = state) do
    with {:ok, %{"puuid" => puuid}} <- fetch_summoner_puuid(state.user.summoner_name, subdomain),
         {:ok, recent_summoners} <- do_fetch_recent_summoners(puuid, region) do
      {:ok, recent_summoners}
    else
      {:error, error} ->
        {:error, error}
    end
  end

  defp do_fetch_recent_summoners(puuid, region) do
    with {:ok, matches} <-
           match_module().fetch_recent_match_ids(puuid, region),
         {:ok, participants} <- match_module().fetch_participants_from_match_ids(matches, region) do
      {:ok, participants}
    end
  end

  def print_recent_player_list(recent_summoners) do
    # TODO: Figure out how to better handle players with a blank Summoner Name
    recent_summoners
    |> Enum.reduce("##### Recent summoners: ######\n \n", fn %{summoner_name: summoner_name},
                                                             acc ->
      acc <> "#{summoner_name} \n"
    end)
    |> ConsoleMessage.print_message()
  end

  # If the user only knows their region we have to iterate through the subdomains
  # for that region to find which one to use. Alternatively we could set it up
  # to iterate through ALL of the subdomains in case the user inputs the incorrect
  # region
  defp fetch_summoner_puuid_by_region(summoner_name, region) do
    region
    |> Util.fetch_subdomains_for_region()
    |> Enum.map(fn subdomain ->
      {subdomain, fetch_summoner_puuid(summoner_name, subdomain)}
    end)
    |> Enum.find(fn
      {_subdomain, {:error, {404, _message}}} -> false
      {_subdomain, {:ok, %{"puuid" => _puuid}}} -> true
    end)
    |> IO.inspect()
    |> then(fn
      {subdomain, {:ok, %{"puuid" => puuid}}} ->
        # TODO: Need to add tests for this, extended work
        _ = BlitzChallenge.set_subdomain(subdomain)
        _ = BlitzChallenge.set_user_puuid(puuid)

        {:ok, puuid}

      nil ->
        ConsoleMessage.print_message(
          "Error occurred while fetching summoner data. Possibly invalid Region input."
        )

        {:error, :invalid_region}
    end)
  end

  defp fetch_summoner_puuid(summoner_name, subdomain) do
    summoner_api_module().fetch_summoner(summoner_name, subdomain)
  end

  defp summoner_api_module do
    Application.get_env(:blitz_challenge, :modules)[:summoner_api_module]
  end

  defp match_module do
    Application.get_env(:blitz_challenge, :modules)[:match_module]
  end
end
