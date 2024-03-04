defmodule BlitzChallenge.RiotAPI.SummonerAPI do
  @moduledoc """

  """
  alias BlitzChallenge.RiotAPI.Util

  require Logger

  @expected_error_status_codes Util.expected_error_status_codes()
  @error_reasons Util.error_reasons()
  @name_path "summoner/v4/summoners/by-name/{summoner_name}"
  @riot_api_base_url Application.compile_env!(:blitz_challenge, :riot_api_base_url)

  @callback fetch_summoner(String.t(), String.t()) :: {:ok, map()} | {:error, any()}

  @spec fetch_summoner(String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def fetch_summoner(summoner_name, subdomain) do
    summoner_name
    |> compose_url(subdomain)
    |> http_module().get(Util.headers())
    |> then(fn
      {:ok, response} -> handle_response(response)
      {:error, error} -> handle_error(:unexpected_error, error)
    end)
  end

  defp compose_url(summoner_name, subdomain) do
    "#{@riot_api_base_url}/#{@name_path}"
    |> String.replace("{summoner_name}", summoner_name)
    |> String.replace("{region}", subdomain)
  end

  defp handle_response(%{status: 200, body: body}),
    do: {:ok, Jason.decode!(body)}

  defp handle_response(%{status: status, body: body})
       when status in @expected_error_status_codes,
       do: handle_error(status, Jason.decode!(body))

  defp handle_response(response), do: handle_error(:unexpected_response, response)

  defp handle_error(:unexpected_error, error_response) do
    Logger.error(
      "Unexpected error occurred when making requests to Riot API: #{inspect(error_response)}"
    )

    {:error, :unexpected_error}
  end

  defp handle_error(status_code, error_message) do
    Logger.error("Error occurred when making requests to Riot API: #{inspect(error_message)}")
    {:error, List.keyfind!(@error_reasons, status_code, 0)}
  end

  def http_module do
    Application.get_env(:blitz_challenge, :modules)[:http_module]
  end
end
