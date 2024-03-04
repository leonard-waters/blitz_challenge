defmodule BlitzChallenge.Match do
  @callback check_new_matches(String.t(), String.t()) ::
              {:ok, list()} | {:error, any()}
  @callback fetch_recent_match_ids(String.t(), String.t()) ::
              {:ok, list()} | {:error, any()}
  @callback fetch_participants_from_match_ids([String.t()], map()) ::
              {:ok, map()} | {:error, any()}

  def check_new_matches(puuid, region, recent_match_ids) do
    case api_module().fetch_recent_matches_by_puuid(puuid, region) do
      {:ok, match_ids} -> find_new_match_ids(match_ids, recent_match_ids)
      {:error, error} -> {:error, error}
    end
  end

  def fetch_recent_match_ids(puuid, region) do
    api_module().fetch_recent_matches_by_puuid(puuid, region)
  end

  def fetch_participants_from_match_ids(matches, region) do
    {:ok,
     Enum.map(matches, fn match_id ->
       api_module().fetch_match_participants_by_match_id(match_id, region)
       |> denormalize()
     end)
     |> List.flatten()
     |> Enum.uniq_by(& &1.puuid)}
  end

  defp find_new_match_ids(match_ids, recent_match_ids) do
    case Enum.reject(match_ids, fn match_id -> match_id in recent_match_ids end) do
      match_ids when match_ids != [] -> {:ok, match_ids}
      [] -> :ok
    end
  end

  defp denormalize(
         {:ok,
          %{
            "info" => %{"participants" => participants},
            "metadata" => %{"matchId" => match_id}
          }}
       ) do
    Enum.map(participants, fn participant ->
      %{
        puuid: participant["puuid"],
        summoner_name: participant["summonerName"],
        match_id: match_id
      }
    end)
  end

  defp api_module do
    Application.get_env(:blitz_challenge, :modules)[:match_api_module]
  end
end
