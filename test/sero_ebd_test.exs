defmodule SeroEbdTest do
  use ExUnit.Case
  doctest SeroEbd

  setup %{} do
    SeroEbd.reset_data("1")
  end

  test "a request to a non existent device will timeout" do
    result = SeroEbd.modbus_send("1", 100, :rhr, 100, 1)

    assert {:error, :device_timeout} == result
  end

  test "send a read request to an environmental sensor" do
    result = SeroEbd.modbus_send("1", 30, :rhr, 100, 1)

    assert 1 == length(result)
    assert 200 == hd(result)
  end

  # test "send a write request to an environment sensor" do
  #   SeroEbd.modbus_send("1", 30, :phr, 100, 205)

  #   result = SeroEbd.modbus_send("1", 30, :rhr, 100, 1)

  #   assert 1 == length(result)
  #   assert 205 == hd(result)
  # end

  # test "send a read request to an unknown register on an environment sensor" do
  #   result = SeroEbd.modbus_send("1", 30, :rhr, 200, 1)

  #   assert {:error, :eaddr} == result
  # end

  #  test "send a read request to a missing channel" do
  #   result = SeroEbd.modbus_send("2", 100, :rhr, 100, 1)

  #   assert {:error, :channel_timeout} == result
  # end

  #   test "send read request to read multiple consecutive registers from an environmental sensor" do
  #   result = SeroEbd.modbus_send("1", 30, :rhr, 100, 3)

  #   assert 3 == length(result)
  #   assert [200, 300, 400] == result
  # end
end
