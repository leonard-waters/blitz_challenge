# BlitzChallenge

  - Add your `RIOT_API_KEY` to the `.env` file and then `source .env` in terminal
  - Run via `mix run --no-halt`

# Notes:

- definitely needs more test coverage
- lots of areas to make it more clean and user friendly
  - started on this with a more colorful console input, but it was a time suck
- a handful of TODOs listed that I might take on later
- needs considerably better/cleaner error handling
- needs specs as well, but I didnt get around to adding dialyzer yet


# Criteria

Create a mix project application that:
- Given a valid summoner_name and region will fetch all summoners this summoner
has played with in the last 5 matches. This data is returned to the caller as a list of
summoner names (see below). Also, the following occurs:
  - Once fetched, all summoners will be monitored for new matches every minute for
the next hour
  - When a summoner plays a new match, the match id is logged to the console,
such as:
- Summoner <summoner name> completed match <match id>
- The returned data should be formatted as: `[summoner_name_1, summoner_name_2, ...]`
- Please upload this project to Github and send us the link.

Notes:
- Make use of Riot Developer API
  - https://developer.riotgames.com/apis
  - https://developer.riotgames.com/apis#summoner-v4
  - https://developer.riotgames.com/apis#match-v5
- You will have to generate an api key. Please make this configurable so we can
substitute our own key in order to test.
