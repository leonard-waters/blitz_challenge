defmodule BlitzChallenge.RiotAPI.UtilTest do
  use BlitzChallenge.Case

  alias BlitzChallenge.RiotAPI.Util

  describe "determine_match_region/1" do
    test "successfully return subdomain list for valid region" do
      assert Util.fetch_subdomains_for_region("americas") == ["na1", "br1", "la1", "la2"]
      assert Util.fetch_subdomains_for_region("Americas") == ["na1", "br1", "la1", "la2"]
      assert Util.fetch_subdomains_for_region("north america") == nil
    end
  end

  describe "find_region_by_subdomain/1" do
    test "returns a region for every subdomain subdomain" do
      for subdomain <- Util.subdomains() do
        assert Util.find_region_by_subdomain(subdomain)
      end
    end
  end
end
