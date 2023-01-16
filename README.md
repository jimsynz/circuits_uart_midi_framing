# Circuits.UART.Framing.MIDI

[![pipeline status](https://gitlab.com/jimsy/angle/badges/main/pipeline.svg)](https://gitlab.com/jimsy/angle/commits/main)
[![Hex.pm](https://img.shields.io/hexpm/v/angle.svg)](https://hex.pm/packages/angle)
[![Hippocratic License HL3-FULL](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-FULL&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/full.html)

Implements a simple framing that splits incoming serial data into individual
messages.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `circuits_uart_midi_framing` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:circuits_uart_midi_framing, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/circuits_uart_midi_framing](https://hexdocs.pm/circuits_uart_midi_framing).

## License

This software is licensed under the terms of the
[HL3-FULL](https://firstdonoharm.dev), see the `LICENSE.md` file included with
this package for the terms.

This license actively proscribes this software being used by and for some
industries, countries and activities.  If your usage of this software doesn't
comply with the terms of this license, then [contact me](mailto:james@harton.nz)
with the details of your use-case to organise the purchase of a license - the
cost of which may include a donation to a suitable charity or NGO.
