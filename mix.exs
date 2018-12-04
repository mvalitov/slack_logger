defmodule SlackLogger.MixProject do
  use Mix.Project

  def project do
    [
      app: :slack_logger,
      version: "0.2.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      homepage_url: "https://hexdocs.pm/slack_logger",
      source_url: "https://github.com/mvalitov/slack_logger",
      description: "A simple Logger backend for sending logs to slack",
      docs: [main: "readme",
          extras: ["README.md"]],
      deps: deps(),
      package: package()
    ]
  end

  def package do
    [name: :slack_logger,
     files: ["lib", "mix.exs"],
     maintainers: ["Marsel Valitov"],
     licenses: ["MIT"],
     links: %{"Github" => "https://github.com/mvalitov/slack_logger"}]
  end
  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.0.0"},
      {:httpoison, "~> 0.12"},
      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
