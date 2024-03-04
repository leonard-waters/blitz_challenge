alias BlitzChallenge.RiotAPI

Mox.defmock(BlitzChallenge.ConsoleMessageMock, for: BlitzChallenge.ConsoleMessage.Behaviour)

Mox.defmock(BlitzChallenge.SummonerMock, for: BlitzChallenge.Summoner)
Mox.defmock(BlitzChallenge.MatchMock, for: BlitzChallenge.Match)

Mox.defmock(RiotAPI.SummonerAPIMock, for: RiotAPI.SummonerAPI)
Mox.defmock(RiotAPI.MatchAPIMock, for: RiotAPI.MatchAPI)

Mox.defmock(BlitzChallenge.HTTPMock, for: BlitzChallenge.HTTP.Behaviour)

ExUnit.start()
