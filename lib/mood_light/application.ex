defmodule MoodLight.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MoodLight.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: MoodLight.Worker.start_link(arg)
        # {MoodLight.Worker, arg},
        Plug.Cowboy.child_spec(
          scheme: :http,
          plug: MoodLight.Server,
          options: [port: 9021]
        )
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: MoodLight.Worker.start_link(arg)
      # {MoodLight.Worker, arg},
      %{
        id: DevMode.Watcher,
        start:
          {DevMode.Watcher, :start_link,
           [
             [
               dirs: ["priv", "lib"],
               backend: :fs_poll
             ]
           ]}
      }
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: MoodLight.Worker.start_link(arg)
      # {MoodLight.Worker, arg},
      MoodLight.Startup
    ]
  end

  def target do
    Application.get_env(:mood_light, :target)
  end
end
