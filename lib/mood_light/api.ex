defmodule MoodLight.API do
  @moduledoc false
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/foo" do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Jason.encode!(%{ola: :foo}))
  end

  get "/info" do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(
      200,
      Jason.encode!(%{
        uptime: uptime()
      })
    )
  end

  match(_, do: send_resp(conn, 404, "oops"))

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
