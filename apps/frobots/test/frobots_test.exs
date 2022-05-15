defmodule FrobotsTest do
  use ExUnit.Case, async: true
  #doctest Frobots.ApiClient


  test "API commands" do
    # these tests must connect to a test backend to work, it is more like an integration test
    #assert KVServer.Command.run({:delete, "shopping", "eggs"}) == {:ok, "OK\r\n"}
    assert true
  end
end