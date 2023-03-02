defmodule SeroEbd.ModbusSim do
  @moduledoc """
  Very simple Modbus simulator
  """

  use GenServer

  def start_link(opts) do
    name = get_process_name(Keyword.get(opts, :id, 0))

    GenServer.start_link(__MODULE__, %{}, name: name)
  end

  @impl true
  def init(_state) do
    state = initial_data()

    {:ok, state}
  end

  # Initial device data
  #  %{
  #     30 => %{ <= device address
  #       {:hr, 100} => 200, <= value is 200 in the holding register at address 100
  #       {:hr, 101} => 300,
  #       {:hr, 102} => 400
  #     }
  #   }
  defp initial_data() do
    %{
      30 => %{
        {:hr, 100} => 200,
        {:hr, 101} => 300,
        {:hr, 102} => 400
      }
    }
  end

  @doc """
  Send a request to the specified simulator that resets the device data
  """
  def reset_data(pid) do
    GenServer.cast(pid, :reset_data)
  end

  @doc """
  Return the process name from a channel ID
  """
  def get_process_name(channel) when is_binary(channel) do
    ("modbus_sim_" <> channel)
    |> String.to_atom()
  end

  @doc """
  Send a request to the specified simulator
  """
  def send(pid, device_address, register, address, length) do
    GenServer.call(pid, {device_address, register, address, length})
  end

  @impl true
  @doc """
  Reset the simulator device data to the initial state
  """
  def handle_cast(:reset_data, _state) do
    state = initial_data()

    {:noreply, state}
  end

  @impl true
  @doc """
  Request the device data at an address in the holding register
  """
  def handle_call({device_address, :rhr, address, _length}, _from, state) do
    maybe_result =
      get_device(state, device_address)
      |> get_address_value(:hr, address)

    result =
      case maybe_result do
        {:ok, data} ->
          [data]

        other ->
          other
      end

    {:reply, result, state}
  end

  # get the device data from the current devices
  defp get_device(state, device_address) do
    Map.get(state, device_address)
  end

  # Device was not found - simulate timeout
  defp get_address_value(nil, _register, _address) do
    {:error, :device_timeout}
  end

  # Get the value at address/register from the device
  defp get_address_value(device_data, register, address) do
    key = {register, address}

    case Map.get(device_data, key) do
      nil ->
        []

      other ->
        {:ok, other}
    end
  end
end
