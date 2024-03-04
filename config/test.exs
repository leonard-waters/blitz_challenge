import Config

config :blitz_challenge,
  riot_api_key: "test_api_key",
  riot_api_base_url: "https://{region}.api.riotgamestest.com/lol"

config :blitz_challenge, :modules,
  console_input_module: BlitzChallenge.ConsoleMessageStub,
  http_module: BlitzChallenge.HTTPMock,
  match_api_module: BlitzChallenge.RiotAPI.MatchAPIMock,
  match_module: BlitzChallenge.MatchMock,
  summoner_api_module: BlitzChallenge.RiotAPI.SummonerAPIMock,
  summoner_module: BlitzChallenge.SummonerMock

config :logger,
  level: :debug,
  backends: [:console]
