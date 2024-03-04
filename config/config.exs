import Config

config :logger,
  level: :debug,
  backends: [:console]

riot_api_key =
  if config_env() == :test,
    do: System.fetch_env!("TEST_RIOT_API_KEY"),
    else: System.fetch_env!("RIOT_API_KEY")

riot_api_base_url =
  if config_env() == :test,
    do: System.fetch_env!("TEST_RIOT_API_BASE_URL"),
    else: System.fetch_env!("RIOT_API_BASE_URL")

config :blitz_challenge,
  env: config_env(),
  riot_api_key: riot_api_key,
  riot_api_base_url: riot_api_base_url

# Modules
config :blitz_challenge, :modules,
  console_input_module: BlitzChallenge.ConsoleMessage,
  http_module: BlitzChallenge.HTTP,
  match_module: BlitzChallenge.Match,
  match_api_module: BlitzChallenge.RiotAPI.MatchAPI,
  summoner_api_module: BlitzChallenge.RiotAPI.SummonerAPI,
  summoner_module: BlitzChallenge.Summoner

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
