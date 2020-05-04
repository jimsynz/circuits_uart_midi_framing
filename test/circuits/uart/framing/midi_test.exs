defmodule Circuits.UART.Framing.MIDITest do
  use ExUnit.Case
  doctest Circuits.UART.Framing.MIDI

  test "greets the world" do
    assert Circuits.UART.Framing.MIDI.hello() == :world
  end
end
