defmodule MoodLight.Startup do
  @moduledoc false
  use GenServer

  require Logger

  alias Blinkchain.Color

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  defmodule State do
    defstruct [:timer, :index]
  end

  @impl true
  def init(_) do
    {:ok, ref} = :timer.send_interval(500, :draw_frame)

    state = %State{
      timer: ref,
      index: 0
    }

    {:ok, state}
  end

  def handle_info(:draw_frame, %{timer: t, index: i}) do
    Logger.info(":draw_frame #{i}")

    Blinkchain.set_pixel({i, i}, Color.parse("#4dffb1"))
    Blinkchain.set_pixel({7 - i, i}, Color.parse("#4dffb1"))

    Blinkchain.render()
    if i == 3, do: :timer.cancel(t)
    {:noreply, %State{timer: t, index: i+1}}
  end
end
