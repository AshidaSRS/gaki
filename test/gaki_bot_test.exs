defmodule GakiBotTest do
  use ExUnit.Case
  doctest GakiBot

  test "greets the world" do
    assert GakiBot.hello() == :world
  end
end
