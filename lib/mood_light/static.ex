defmodule MoodLight.Static do
  use Plug.Builder

  plug(Plug.Static,
    at: "/",
    from: :mood_light
  )
end
