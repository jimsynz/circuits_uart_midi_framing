defmodule Circuits.UART.Framing.MIDI.MixProject do
  use Mix.Project

  @version "0.1.0"

  @description """
  Implements MIDI framing for Serial ports connected via Circuits.UART.
  """

  def project do
    [
      app: :circuits_uart_midi_framing,
      version: @version,
      elixir: "~> 1.10",
      package: package(),
      description: @description,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def package do
    [
      maintainers: ["James Harton <james@harton.nz>"],
      licenses: ["Hippocratic"],
      links: %{
        "Source" => "https://gitlab.com/jimsy/circuits_uart_midi_framing"
      }
    ]
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
      {:circuits_uart, "~> 1.4"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:earmark, ">= 0.0.0", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]},
      {:git_ops, "~> 2.3", only: ~w[dev test]a, runtime: false}
    ]
  end
end
