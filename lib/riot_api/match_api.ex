defmodule BlitzChallenge.RiotAPI.MatchAPI do
  @moduledoc """

  """
  alias BlitzChallenge.RiotAPI.Util

  require Logger

  @expected_error_status_codes Util.expected_error_status_codes()
  @error_reasons Util.error_reasons()
  @match_by_puuid_path "match/v5/matches/by-puuid/{puuid}/ids?start=0&count=5"
  @participants_by_match_id_path "match/v5/matches/{match_id}"

  @callback fetch_recent_matches_by_puuid(String.t(), String.t()) ::
              {:ok, map()} | {:error, any()}
  @callback fetch_match_participants_by_match_id(String.t(), String.t()) ::
              {:ok, map()} | {:error, any()}

  def fetch_recent_matches_by_puuid(puuid, region) do
    :puuid
    |> compose_url(puuid, region)
    |> http_module().get(Util.headers())
    |> then(fn
      {:ok, response} -> handle_response(response)
      {:error, error} -> handle_error(:unexpected_response, error)
    end)
  end

  def fetch_match_participants_by_match_id(match_id, region) do
    :match_id
    |> compose_url(match_id, region)
    |> http_module().get(Util.headers())
    |> then(fn
      {:ok, response} -> handle_response(response)
      {:error, error} -> handle_error(:unexpected_response, error)
    end)
  end

  defp compose_url(:puuid, puuid, region) do
    "#{riot_api_base_url()}/#{@match_by_puuid_path}"
    |> String.replace("{puuid}", puuid)
    |> String.replace("{region}", region)
  end

  defp compose_url(:match_id, match_id, region) do
    "#{riot_api_base_url()}/#{@participants_by_match_id_path}"
    |> String.replace("{match_id}", match_id)
    |> String.replace("{region}", region)
  end

  defp handle_response(%{status: 200, body: body}),
    do: {:ok, Jason.decode!(body)}

  defp handle_response(%{status: status, body: body})
       when status in @expected_error_status_codes,
       do: handle_error(status, Jason.decode!(body))

  defp handle_response(response), do: handle_error(:unexpected_response, response)

  defp handle_error(:unexpected_response, error_response) do
    Logger.error(
      "Unexpected error occurred when making requests to Riot API: #{inspect(error_response)}"
    )

    {:error, :unexpected_response}
  end

  defp handle_error(status_code, error_message) do
    Logger.error("Error occurred when making requests to Riot API: #{inspect(error_message)}")
    {:error, Keyword.fetch!(@error_reasons, status_code)}
  end

  defp riot_api_base_url do
    Application.get_env(:blitz_challenge, :riot_api_base_url)
  end

  defp http_module do
    Application.get_env(:blitz_challenge, :modules)[:http_module]
  end
end
