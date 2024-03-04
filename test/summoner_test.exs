defmodule BlitzChallenge.SummonerTest do
  use BlitzChallenge.Case, async: true

  import Mox

  alias BlitzChallenge.{Summoner, MatchMock}
  alias BlitzChallenge.RiotAPI.{SummonerAPIMock}
  alias BlitzChallenge.Support.Fixtures

  setup :verify_on_exit!

  setup do
    MatchMock
    |> stub(:fetch_recent_match_ids, fn _, _ -> {:ok, Fixtures.match_ids()} end)
    |> stub(:fetch_participants_from_match_ids, fn _, _ ->
      {:ok, Fixtures.recent_summoners()}
    end)

    :ok
  end

  describe "fetch_recent_summoners/1" do
    test "returns summoner successfully when subdomain is provided" do
      expected_summoner_name = Fixtures.user_summoner_name()
      expected_subdomain = Fixtures.subdomain()
      expected_recent_summoners = Fixtures.recent_summoners()

      state = %{
        user: %{summoner_name: expected_summoner_name, puuid: nil},
        region: nil,
        subdomain: expected_subdomain,
        recent_summoners: nil
      }

      expect(SummonerAPIMock, :fetch_summoner, fn ^expected_summoner_name, ^expected_subdomain ->
        {:ok, %{"name" => expected_summoner_name, "puuid" => "mocked_puuid"}}
      end)

      assert Summoner.fetch_recent_summoners(state) == {:ok, expected_recent_summoners}
    end

    test "returns summoner successfully when only region is known" do
      expected_summoner_name = Fixtures.user_summoner_name()
      expected_region = Fixtures.region()
      expected_recent_summoners = Fixtures.recent_summoners()
      expected_subdomain = Fixtures.subdomain()

      state = %{
        user: %{summoner_name: expected_summoner_name, puuid: nil},
        region: expected_region,
        subdomain: nil,
        recent_summoners: nil
      }

      not_found_message = %{
        "status" => %{
          "message" => "Data not found - summoner not found",
          "status_code" => 404
        }
      }

      success_message = %{"name" => expected_summoner_name, "puuid" => "mocked_puuid"}

      expect(SummonerAPIMock, :fetch_summoner, 4, fn
        ^expected_summoner_name, ^expected_subdomain ->
          {:ok, success_message}

        ^expected_summoner_name, _subdomain ->
          {:ok, not_found_message}
      end)

      assert Summoner.fetch_recent_summoners(state) == {:ok, expected_recent_summoners}
    end
  end
end
