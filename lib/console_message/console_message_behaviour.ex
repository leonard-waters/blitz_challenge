defmodule BlitzChallenge.ConsoleMessage.Behaviour do
  @callback request_subdomain_input() :: String.t() | nil
  @callback request_region_input() :: String.t() | nil
  @callback request_summoner_name_input() :: String.t() | nil
  @callback request_all_user_input() :: map()
  @callback print_message(String.t()) :: :ok
end
