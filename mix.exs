defmodule Rsyslog.MixProject do
  use Mix.Project

  def project do
    [
      app: :nsyslog,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {NSyslog.Application, []},
      applications: [:ssl],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
