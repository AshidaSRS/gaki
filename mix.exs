defmodule GakiBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :gaki_bot,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GakiBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, "~> 0.23"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, "~> 1.2"},
      {:logger_file_backend, "0.0.11"},
      {:ecto_sql, "~> 3.5"},
      {:postgrex, "~> 0.15"},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:uuid, "~> 1.1"}
    ]
  end
end
