defmodule MoodLightTest do
  use ExUnit.Case
  doctest MoodLight

  test "greets the world" do
    assert MoodLight.hello() == :world
  end
end
