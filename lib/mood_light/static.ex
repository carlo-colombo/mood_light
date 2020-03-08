defmodule MoodLight.Static do
  use Plug.Builder

  plug(:append_index)

  plug(Plug.Static,
    at: "/",
    from: :mood_light
  )

  plug(:not_found)

  defp append_index(conn, _) do
    if String.match?(conn.request_path, ~r|^(.*/)?$|) do
      %{
        conn
        | request_path: "#{conn.request_path}index.html",
          path_info: conn.path_info ++ ["index.html"]
      }
    else
      conn
    end
  end

  def not_found(conn, _) do
    send_resp(conn, 404, "not found")
  end
end
