defmodule BlitzChallenge.Case do
  use ExUnit.CaseTemplate

  import Mox

  alias BlitzChallenge.ConsoleMessage.Stub, as: ConsoleMessageStub

  setup _ do
    BlitzChallenge.ConsoleMessageMock
    |> stub(:request_all_user_input, fn -> ConsoleMessageStub end)
    |> stub(:print_message, fn -> ConsoleMessageStub end)


    :ok
  end
end
