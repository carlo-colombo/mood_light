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
  forward("/public", to: MoodLight.Static)

  match(_, do: send_resp(conn, 404, "oops MoodLigth"))
end
