defmodule BlitzChallenge.MatchTest do
  use BlitzChallenge.Case, async: true

  import Mox
  alias BlitzChallenge.Match
  alias BlitzChallenge.Support.Fixtures
  alias BlitzChallenge.RiotAPI.MatchAPIMock

  setup :verify_on_exit!

  describe "check_new_matches/3" do
    test "returns a list of the last 5 matches the summoner played" do
      expected_puuid = Fixtures.puuid()
      expected_region = Fixtures.region()
      expected_match_list = Fixtures.match_ids()
      new_match_ids = ["NA_190238392"]

      expect(MatchAPIMock, :fetch_recent_matches_by_puuid, fn ^expected_puuid, ^expected_region ->
        {:ok, new_match_ids}
      end)

      assert BlitzChallenge.Match.check_new_matches(
               expected_puuid,
               expected_region,
               expected_match_list
             ) ==
               {:ok, new_match_ids}
    end

    test "returns :ok when there are no new matches, only known match_ids" do
      expected_puuid = Fixtures.puuid()
      expected_region = Fixtures.region()
      expected_match_list = Fixtures.match_ids()

      expect(MatchAPIMock, :fetch_recent_matches_by_puuid, fn ^expected_puuid, ^expected_region ->
        {:ok, expected_match_list}
      end)

      assert BlitzChallenge.Match.check_new_matches(
               expected_puuid,
               expected_region,
               expected_match_list
             ) == :ok
    end

    test "returns :ok when the api returns an empty list" do
      expected_puuid = Fixtures.puuid()
      expected_region = Fixtures.region()
      expected_match_list = Fixtures.match_ids()

      expect(MatchAPIMock, :fetch_recent_matches_by_puuid, fn ^expected_puuid, ^expected_region ->
        {:ok, []}
      end)

      assert BlitzChallenge.Match.check_new_matches(
               expected_puuid,
               expected_region,
               expected_match_list
             ) == :ok
    end
  end

  describe "fetch_recent_match_ids/2" do
    test "returns a list of the last 5 matches the summoner played" do
      expected_puuid = Fixtures.puuid()
      expected_region = Fixtures.region()
      expected_match_list = Fixtures.match_ids()

      expect(MatchAPIMock, :fetch_recent_matches_by_puuid, fn ^expected_puuid, ^expected_region ->
        {:ok, expected_match_list}
      end)

      assert BlitzChallenge.Match.fetch_recent_match_ids(expected_puuid, expected_region) ==
               {:ok, expected_match_list}
    end
  end

  describe "fetch_participants_from_match_ids/2" do
    test "returns the expected list of participants from the match_ids" do
      expected_region = Fixtures.region()
      expected_match_list = Fixtures.match_ids()
      expected_response = Fixtures.decoded_match_response()
      expected_recent_summoners = Fixtures.recent_summoners()

      expect(MatchAPIMock, :fetch_match_participants_by_match_id, 5, fn match_id,
                                                                        ^expected_region ->
        assert match_id in expected_match_list
        {:ok, expected_response}
      end)

      assert Match.fetch_participants_from_match_ids(expected_match_list, expected_region) ==
               {:ok, expected_recent_summoners}
    end
  end
end
