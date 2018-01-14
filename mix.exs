defmodule MastodonIndex.Mixfile do
  use Mix.Project

  def project do
    [app: :mastodon_index,
     version: "0.1.0",
     elixir: "~> 1.5",
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger],
     mod: {MastodonIndex, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:elastic, "~> 3.0.0"},
     {:couchdb_connector, "~> 0.5.0"},
     {:tesla, "~> 0.10.0"},
     {:httpoison, "~> 0.13.0"},
     {:poison, "~> 3.1.0"}]
  end
end
