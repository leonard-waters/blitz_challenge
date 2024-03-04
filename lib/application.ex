defmodule BlitzChallenge.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: BlitzChallenge.Finch},
      BlitzChallenge.Summoner.MatchMonitorSupervisor,
      BlitzChallenge
    ]

    IO.puts("Application started....")
    opts = [strategy: :one_for_one, name: BlitzChallenge.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
