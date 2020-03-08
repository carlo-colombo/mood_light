defmodule MoodLight.Server do
  @moduledoc false

  use Plug.Router

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  forward("/api", to: MoodLight.API)
  forward("/", to: MoodLight.Static)
end
