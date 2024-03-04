defmodule BlitzChallengeTest do
  use BlitzChallenge.Case

  import Mox

  describe "request_user_input/0" do
    test "when the value of subdomain is nil the region is requested" do
      expect(BlitzChallenge.ConsoleMessageMock, :request_subdomain_input, fn -> nil end)

      expect(BlitzChallenge.ConsoleMessageMock, :request_region_input, fn ->
        "americas"
      end)
    end
  end
end
