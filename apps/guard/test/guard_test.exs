defmodule GuardTest do
  use ExUnit.Case
  doctest Guard

  test "greets the world" do
    assert Guard.hello() == :world
  end
end
