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

    defp uptime do
        {ut, _} = :erlang.statistics(:wall_clock)
        {d, {h, m, s}} = :calendar.seconds_to_daystime(div(ut,1000))
        Enum.filter([
            d>0 && "#{d} days, ",
            d+h>0 && "#{h} hours, ",
            d+h+m>0 && "#{m} minutes and ",
            "#{s} seconds"
        ], &(&1))
        |> Enum.join
    end

    get "/info" do
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(200, Jason.encode!(%{
            uptime: uptime()
        }))
      end
  
    match _ do
      send_resp(conn, 404, "oops")
    end
  end