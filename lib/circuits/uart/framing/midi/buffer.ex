defmodule Circuits.UART.Framing.MIDI.Buffer do
  alias __MODULE__
  defstruct buffer: <<>>

  @type t :: %Buffer{buffer: binary}

  @moduledoc """
  Implements a buffer for incoming serial data.
  """

  @doc """
  Initialise a new empty buffer.
  """
  @spec init :: Buffer.t()
  def init, do: %Buffer{}

  @doc """
  Consume as much of the buffer as possible, splitting it into messages.
  """
  def get_packets(%Buffer{buffer: buffer}) do
    with {:ok, buffer} <- drop_leading_data_bytes(buffer),
         {:ok, messages, buffer} <- consume_messages([], buffer) do
      {:ok, messages, %Buffer{buffer: buffer}}
    else
      :error -> {:ok, [], %Buffer{buffer: buffer}}
    end
  end

  @doc """
  Apend new data onto the end of the buffer.
  """
  @spec append(Buffer.t(), binary) :: Buffer.t()
  def append(%Buffer{buffer: buffer}, data) when is_binary(data),
    do: %Buffer{buffer: buffer <> data}

  @doc """
  Indicates whether the buffer is empty or not.
  """
  @spec empty?(Buffer.t()) :: boolean
  def empty?(%Buffer{buffer: <<>>}), do: true
  def empty?(%Buffer{}), do: false

  defp consume_status_byte(<<1::integer-size(1), byte::bitstring-size(7), rest::binary>>),
    do: {:ok, <<1::integer-size(1), byte::bitstring-size(7)>>, rest}

  defp consume_status_byte(data), do: {:error, data}

  defp consume_data_byte(<<0::integer-size(1), byte::bitstring-size(7), rest::binary>>),
    do: {:ok, <<0::integer-size(1), byte::bitstring-size(7)>>, rest}

  defp consume_data_byte(data), do: {:error, data}

  defp drop_leading_data_bytes(data) when is_binary(data) do
    data
    |> consume_data_byte()
    |> drop_leading_data_bytes()
  end

  defp drop_leading_data_bytes({:ok, _byte, <<>>}), do: :error

  defp drop_leading_data_bytes({:ok, _byte, data}) do
    data
    |> consume_data_byte()
    |> drop_leading_data_bytes()
  end

  defp drop_leading_data_bytes({:error, data}), do: {:ok, data}

  defp consume_data_bytes(bytes, <<>>), do: {:ok, bytes, <<>>}

  defp consume_data_bytes(bytes, data) do
    case consume_data_byte(data) do
      {:ok, byte, rest} -> consume_data_bytes(bytes <> byte, rest)
      {:error, rest} -> {:ok, bytes, rest}
    end
  end

  defp consume_messages(messages, <<>>), do: {:ok, Enum.reverse(messages), <<>>}

  defp consume_messages(messages, data) when is_binary(data) do
    case consume_message(data) do
      {:ok, message, rest} -> consume_messages([message | messages], rest)
      {:error, rest} -> {:ok, messages, rest}
    end
  end

  defp consume_message(data) when is_binary(data) do
    case consume_status_byte(data) do
      {:ok, <<0xF0>>, rest} -> consume_sysex_payload(<<0xF0>>, rest)
      {:ok, status_byte, rest} -> consume_data_bytes(status_byte, rest)
      {:error, rest} -> {:error, rest}
    end
  end

  defp consume_sysex_payload(payload, <<0xF7, rest::binary>>), do: {:ok, payload, rest}
  defp consume_sysex_payload(payload, <<>>), do: {:ok, <<>>, payload}

  defp consume_sysex_payload(payload, <<byte::binary-size(1), rest::binary>>),
    do: consume_sysex_payload(payload <> byte, rest)
end
