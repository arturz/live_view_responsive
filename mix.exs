defmodule LiveViewResponsive.MixProject do
  use Mix.Project

  def project do
    [
      app: :live_view_responsive,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [
        warnings_as_errors: true
      ],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},

      # Phoenix LiveView requires Floki as a test dependency.
      {:floki, ">= 0.30.0", only: :test}
    ]
  end

  defp package do
    [
      files: ~w(lib lib_client) ++ ~w(mix.exs package.json LICENSE README.md .formatter.exs),
      maintainers: ["Artur Ziętkiewicz"],
      links: %{
        "GitHub" => "https://github.com/arturz/live_view_responsive"
      },
      licenses: ["MIT"],
      description:
        "Media queries for responsive design in Phoenix LiveView. Heavily inspired by react-responsive."
    ]
  end

  defp docs do
    [
      main: "LiveViewResponsive"
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
