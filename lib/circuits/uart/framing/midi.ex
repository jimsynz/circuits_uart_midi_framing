defmodule Circuits.UART.Framing.MIDI do
  @behaviour Circuits.UART.Framing
  alias __MODULE__.Buffer

  @moduledoc """
  Implements framing for the MIDI protocol.

  It doesn't decode any messages, it simply splits incoming serial frames apart
  into individual MIDI messages as per the specification.
  """

  @impl true
  def init(_args), do: {:ok, Buffer.init()}

  @doc """
  Basically a no-op from a framing point of view.  There's no intra-message
  delimeter required, so we simply return the data unchanged.
  """
  @impl true
  def add_framing(data, state) do
    {:ok, data, state}
  end

  @doc """
  Process incoming data and break it apart into separate MIDI packets.
  """
  @impl true
  def remove_framing(data, %Buffer{} = buffer) do
    buffer = Buffer.append(buffer, data)

    case Buffer.get_packets(buffer) do
      {:ok, messages, %Buffer{buffer: <<>>} = buffer} -> {:ok, messages, buffer}
      {:ok, messages, %Buffer{} = buffer} -> {:in_frame, messages, buffer}
      {:error, reason} -> {:error, reason}
    end
  end

  @impl true
  def frame_timeout(buffer), do: buffer

  @impl true
  def flush(direction, _buffer) when direction == :receive or direction == :both,
    do: Buffer.init()

  def flush(:transmit, buffer), do: buffer
end
