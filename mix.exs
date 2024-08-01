defmodule LiveViewResponsive.MixProject do
  use Mix.Project

  def project do
    [
      app: :live_view_responsive,
      version: "0.1.0",
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
    |> add_application_mod_in_test()
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, ">= 0.18.0"},
      {:phoenix, ">= 1.0.0"},

      # Phoenix LiveView requires Floki as a test dependency.
      {:floki, ">= 0.30.0", only: :test}
    ]
  end

  defp add_application_mod_in_test(application) do
    if Mix.env() == :test do
      application ++ [mod: {LiveViewResponsive.Application, []}]
    else
      application
    end
  end
end
