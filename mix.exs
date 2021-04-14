defmodule Livebook.MixProject do
  use Mix.Project

  def project do
    [
      app: :livebook,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      releases: releases(),
      deps: deps(),
      escript: escript(),
      preferred_cli_env: preferred_cli_env()
    ]
  end

  def application do
    [
      mod: {Livebook.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      # TODO: remove reference to the Git repo once LV 0.15.5 is released
      {:phoenix_live_view, "~> 0.15.0",
       github: "phoenixframework/phoenix_live_view", branch: "master"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:earmark_parser, "~> 1.4"}
    ]
  end

  defp aliases do
    [
      "dev.setup": ["deps.get", "cmd npm install --prefix assets"],
      "dev.build": ["cmd npm run deploy --prefix ./assets"],
      "format.all": ["format", "cmd npm run format --prefix ./assets"]
    ]
  end

  defp escript() do
    [
      main_module: LivebookCLI,
      app: nil
    ]
  end

  defp preferred_cli_env() do
    [
      build: :prod
    ]
  end

  # Required for elixir executables to work in the release image.
  #
  # See: https://github.com/elixir-lang/elixir/issues/9286
  defp releases do
    [
      livebook: [
        steps: [:assemble, &copy_bin_start_boot/1]
      ]
    ]
  end

  defp copy_bin_start_boot(release) do
    start_boot = Path.join(release.erts_source, "../bin/start.boot")
    File.cp(start_boot, Path.join(release.path, "bin/start.boot"))
    release
  end
end
