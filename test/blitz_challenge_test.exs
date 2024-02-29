defmodule BlitzChallengeTest do
  use ExUnit.Case
  doctest BlitzChallenge

  test "greets the world" do
    assert BlitzChallenge.hello() == :world
  end
end
