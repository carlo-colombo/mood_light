defmodule MoodLight.API.Grid do
  @moduledoc false

  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "{}")
  end

  put "/" do
    send_resp(conn, 201, "[]")
  end

  match(_, do: send_resp(conn, 404, "oops"))
end
