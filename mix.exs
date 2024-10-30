defmodule Circuits.UART.Framing.MIDI.MixProject do
  use Mix.Project

  @version "1.0.0"

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
      licenses: ["HL3-FULL"],
      links: %{
        "Source" => "https://harton.dev/james/circuits_uart_midi_framing"
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
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.22", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.16", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30", only: [:dev, :test], runtime: false},
      {:git_ops, "~> 2.4", only: [:dev, :test], runtime: false}
    ]
  end
end
