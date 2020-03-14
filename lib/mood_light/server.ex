defmodule MoodLight.Server do
  @moduledoc false

  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger, otp_app: :my_app
  end

  plug(Plug.Logger)

  plug(:match)
  plug(:dispatch)

  forward("/api", to: MoodLight.API)
  forward("/", to: MoodLight.Static)
end
