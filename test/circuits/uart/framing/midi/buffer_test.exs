defmodule Circuits.UART.Framing.MIDI.BufferTest do
  use ExUnit.Case, async: true
  alias Circuits.UART.Framing.MIDI.Buffer

  @note_off <<0x80, 0x3C, 0x40>>
  @note_on <<0x90, 0x3C, 0x40>>

  describe "init/0" do
    test "it creates an empty buffer" do
      assert %Buffer{buffer: <<>>} = Buffer.init()
    end
  end

  describe "append/2" do
    test "it appends data to the buffer" do
      buffer = %Buffer{buffer: <<0, 1>>}
      buffer = Buffer.append(buffer, <<2, 3>>)
      assert %Buffer{buffer: <<0, 1, 2, 3>>} = buffer
    end
  end

  describe "get_packets/1" do
    test "it can decode a single note-on" do
      {:ok, messages, buffer} =
        Buffer.init()
        |> Buffer.append(@note_on)
        |> Buffer.get_packets()

      assert [@note_on] = messages
      assert Buffer.empty?(buffer)
    end

    test "it can decode a single note-off" do
      {:ok, messages, buffer} =
        Buffer.init()
        |> Buffer.append(@note_off)
        |> Buffer.get_packets()

      assert [@note_off] = messages
      assert Buffer.empty?(buffer)
    end

    test "it drops leading data bytes" do
      {:ok, messages, buffer} =
        Buffer.init()
        |> Buffer.append(<<0, 0, 0>> <> @note_off)
        |> Buffer.get_packets()

      assert [@note_off] = messages
      assert Buffer.empty?(buffer)
    end

    test "it splits multiple messages" do
      {:ok, messages, buffer} =
        Buffer.init()
        |> Buffer.append(@note_on <> @note_off)
        |> Buffer.get_packets()

      assert [@note_on, @note_off] = messages
      assert Buffer.empty?(buffer)
    end

    test "it handles running status" do
      {:ok, messages, buffer} =
        Buffer.init()
        |> Buffer.append(<<0x90, 0x3C, 0x40, 0x3D, 0x40, 0x3E, 0x40>>)
        |> Buffer.get_packets()

      assert [<<0x90, 0x3C, 0x40, 0x3D, 0x40, 0x3E, 0x40>>] = messages
      assert Buffer.empty?(buffer)
    end

    test "it handles multiple messages without data bytes" do
      {:ok, messages, buffer} =
        Buffer.init()
        |> Buffer.append(<<0xFF, 0xFE, 0xF8>>)
        |> Buffer.get_packets()

      assert [<<0xFF>>, <<0xFE>>, <<0xF8>>] = messages
      assert Buffer.empty?(buffer)
    end

    test "it handles arbitrary-length sysex messages" do
      message = <<0xF0, 0x7D>> <> Base.encode64("Marty McFly") <> <<0xF7>>

      {:ok, messages, buffer} =
        Buffer.init()
        |> Buffer.append(message)
        |> Buffer.get_packets()

      assert [message] = messages
      assert Buffer.empty?(buffer)
    end
  end
end
