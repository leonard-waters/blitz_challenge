defmodule BlitzChallenge.RiotAPI.MatchAPITest do
  use BlitzChallenge.Case, async: true

  import Mox

  alias BlitzChallenge.HTTPMock
  alias BlitzChallenge.Support.Fixtures

  @region Fixtures.region()

  @expected_match_id Fixtures.match_id()
  @expected_puuid Fixtures.puuid()
  @expected_headers BlitzChallenge.RiotAPI.Util.headers()
  @decoded_recent_matches_response Fixtures.match_ids()
  @decoded_match_response Fixtures.decoded_match_response()
  @encoded_recent_matches_response Jason.encode!(@decoded_recent_matches_response)
  @encoded_match_response Jason.encode!(@decoded_match_response)

  setup :verify_on_exit!

  describe "fetch_recent_matches_by_puuid/2" do
    test "fetch_recent_matches_by_puuid with default region" do
      expected_url =
        "https://#{@region}.api.riotgamestest.com/lol/match/v5/matches/by-puuid/#{@expected_puuid}/ids?start=0&count=5"

      expect(HTTPMock, :get, fn url, headers ->
        assert url == expected_url
        assert headers == @expected_headers

        {:ok, %Finch.Response{status: 200, body: @encoded_recent_matches_response}}
      end)

      assert BlitzChallenge.RiotAPI.MatchAPI.fetch_recent_matches_by_puuid(
               @expected_puuid,
               @region
             ) ==
               {:ok, @decoded_recent_matches_response}
    end
  end

  describe "fetch_match_participants_by_match_id/2" do
    test "fetch_match_participants_by_match_id region" do
      expected_url =
        "https://#{@region}.api.riotgamestest.com/lol/match/v5/matches/#{@expected_match_id}"

      expect(HTTPMock, :get, fn url, headers ->
        assert url == expected_url
        assert headers == @expected_headers
        {:ok, %Finch.Response{status: 200, body: @encoded_match_response}}
      end)

      assert BlitzChallenge.RiotAPI.MatchAPI.fetch_match_participants_by_match_id(
               @expected_match_id,
               @region
             ) ==
               {:ok, @decoded_match_response}
    end
  end
end
