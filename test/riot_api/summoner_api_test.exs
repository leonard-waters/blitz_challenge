defmodule BlitzChallenge.RiotAPI.SummonerAPITest do
  use BlitzChallenge.Case, async: true

  import Mox

  alias BlitzChallenge.HTTPMock
  alias BlitzChallenge.RiotAPI.Util
  alias BlitzChallenge.Support.Fixtures

  @expected_subdomain Fixtures.subdomain()
  @expected_summoner_name Fixtures.user_summoner_name()
  @expected_puuid Fixtures.puuid()
  @expected_headers Util.headers()

  @decoded_success_response %{
    "id" => "test-xkFy68mp8Htn6l7glGR3mtxNKGqVlH990Gntest",
    "accountId" => "testtMT14Pjw5RJ4XRD6n66FCSv-O9jiKZgxnEAKktest",
    "puuid" => @expected_puuid,
    "name" => @expected_summoner_name,
    "profileIconId" => 6331,
    "revisionDate" => 1_709_353_588_000,
    "summonerLevel" => 183
  }
  @encoded_success_response Jason.encode!(@decoded_success_response)

  setup :verify_on_exit!

  describe "fetch_summoner/3 query_type: name" do
    test "returns the summoner details" do
      expected_url =
        "https://#{@expected_subdomain}.api.riotgamestest.com/lol/summoner/v4/summoners/by-name/#{@expected_summoner_name}"

      expect(HTTPMock, :get, fn url, headers ->
        assert url == expected_url
        assert headers == @expected_headers

        {:ok, %Finch.Response{status: 200, body: @encoded_success_response}}
      end)

      assert BlitzChallenge.RiotAPI.SummonerAPI.fetch_summoner(
               @expected_summoner_name,
               @expected_subdomain
             ) ==
               {:ok, @decoded_success_response}
    end
  end
end
