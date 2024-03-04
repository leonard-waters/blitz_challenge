defmodule BlitzChallenge.HTTP.Behaviour do
  @moduledoc """
  This behaviour includes all functions that make HTTP
  requests. This behaviour is used for creating mocks using the `Mox` library.
  """

  @type url() :: Finch.Request.url()
  @type headers() :: Finch.Request.headers()
  @type response() :: {:ok, Finch.Response.t()} | {:error, Mint.Types.error() | Finch.Error.t()}

  @callback get(url(), headers()) :: response()
end
