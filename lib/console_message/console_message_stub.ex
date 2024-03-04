defmodule BlitzChallenge.ConsoleMessage.Stub do
  @behaviour BlitzChallenge.ConsoleMessage.Behaviour

  @subdomain "na1"
  @region "americas"
  @summoner_name "lateapex"

  def request_subdomain_input, do: @subdomain
  def request_region_input, do: @region
  def request_summoner_name_input, do: @summoner_name
  def print_message(msg), do: msg

  def request_all_user_input,
    do: %{summoner_name: @summoner_name, subdomain: @subdomain, region: @region}
end
