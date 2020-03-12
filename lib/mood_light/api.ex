defmodule MoodLight.API do
  @moduledoc false
  use Plug.Router

  alias Blinkchain.Color

  plug(CORSPlug)
  plug(:common_headers)
  plug(:match)
  plug(:dispatch)

  get "/info" do
    conn
    |> send_resp(
      200,
      Jason.encode!(%{
        uptime: uptime()
      })
    )
  end

  put "/grid" do
    %{"_json" => grid} = conn.params

    spawn(fn ->
      Blinkchain.set_brightness(0, 2)

      for {row, i} <- Enum.with_index(grid) do
        for {led, j} <- Enum.with_index(row) do
          Blinkchain.set_pixel({i, j}, Color.parse(led["color"]))
        end
      end

      Blinkchain.render()
    end)

    conn
    |> send_resp(201, "{}")
  end

  match(_, do: send_resp(conn, 404, "oops"))

  defp common_headers(conn, _opts) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
  end

  defp uptime do
    {ut, _} = :erlang.statistics(:wall_clock)
    {d, {h, m, s}} = :calendar.seconds_to_daystime(div(ut, 1000))

    Enum.filter(
      [
        d > 0 && "#{d} days, ",
        d + h > 0 && "#{h} hours, ",
        d + h + m > 0 && "#{m} minutes and ",
        "#{s} seconds"
      ],
      & &1
    )
    |> Enum.join()
  end
end
