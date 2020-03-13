defmodule MoodLight.MixProject do
  use Mix.Project

  @app :mood_light
  @version "0.1.0"
  @all_targets [:rpi0, :rpi]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.7"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MoodLight.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :inets
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.5.0", runtime: false},
      {:shoehorn, "~> 0.6"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:cors_plug, "~> 2.0"},
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
      {:blinkchain, "~> 1.0", runtime: false},
      {:file_system, "~> 0.2", runtime: false},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_pack, "~> 0.2", targets: @all_targets},
      {:vintage_net_wizard, "~> 0.1", targets: @all_targets},
      {:nerves_firmware_ssh, "~> 0.4", targets: @all_targets},
      {:blinkchain, "~> 1.0.0", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi0, "~> 1.10", runtime: false, targets: :rpi0},
      {:nerves_system_rpi, "~> 1.10", runtime: false, targets: :rpi}
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end
end
