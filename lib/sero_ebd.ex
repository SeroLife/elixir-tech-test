defmodule SeroEbd do
  @moduledoc """
  Documentation for `SeroEbd`.
  """

  alias SeroEbd.ModbusSim

  @doc """
  Send data to a modbus device

  channel - tty channel to transmit on
  device_address - the physical device address on the wire
  register - the register back within the device
  address - the address within the register bank
  length_or_value - the number of registers to read or the value to write
  """
  def modbus_send(channel, device_address, register, address, length_or_value) do
    name = ModbusSim.get_process_name(channel)

    case Process.whereis(name) do
      nil ->
        :error

      pid ->
        ModbusSim.send(pid, device_address, register, address, length_or_value)
    end
  end

  @doc """
  Reset the data in a specified modbus simulator
  """
  def reset_data(channel) do
    name = ModbusSim.get_process_name(channel)

    case Process.whereis(name) do
      pid ->
        ModbusSim.reset_data(pid)
    end
  end
end
