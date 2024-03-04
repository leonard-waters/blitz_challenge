defmodule BlitzChallenge.HTTP do
  @behaviour BlitzChallenge.HTTP.Behaviour

  @impl BlitzChallenge.HTTP.Behaviour
  def get(url, headers \\ []) do
    :get
    |> Finch.build(url, headers)
    |> Finch.request(BlitzChallenge.Finch)
  end
end
