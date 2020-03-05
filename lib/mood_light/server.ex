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
  
    get "/api" do
      conn
      |> put_resp_header("content-type", "application/json; charset=utf-8")
      |> send_resp(200, Jason.encode!(%{ola: :foo}))
    end

    get "/info" do
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(200, Jason.encode!(%{
            uptime: Toolshed.Unix.uptime
        }))
      end
  
    match _ do
      send_resp(conn, 404, "oops")
    end
  end