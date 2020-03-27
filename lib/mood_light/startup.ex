defmodule MoodLight.Startup do
  @moduledoc false
  use GenServer

  require Logger

  alias Blinkchain.Color

  defp frame1(i) do
    Blinkchain.set_pixel({i, i}, Color.parse("#4dffb1"))
    Blinkchain.set_pixel({7 - i, i}, Color.parse("#4dffb1"))
  end

  defp frame2(i) do
    Blinkchain.set_pixel({i + 1, i}, Color.parse("#ff0000"))
    Blinkchain.set_pixel({6 - i, i}, Color.parse("#ff0000"))
  end

  defp reset do
    Blinkchain.fill({0, 0}, 8, 4, %Blinkchain.Color{})
  end

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  defmodule State do
    @moduledoc false
    defstruct [:timer, :index, :frames]
  end

  @impl true
  def init(_) do
    {:ok, ref} = :timer.send_interval(500, :draw_frame)

    state = %State{
      timer: ref,
      frames: [
        {&reset/0}
        | (List.duplicate(&frame1/1, 4) |> Enum.with_index()) ++
            (List.duplicate(&frame2/1, 4) |> Enum.with_index())
      ]
    }

    {:ok, state}
  end

  @impl true
  def handle_info(:draw_frame, %{timer: t, frames: frames}) do
    Logger.info(":draw_frame frames left: #{length(frames)}")

    frames =
      case List.pop_at(frames, 0) do
        {{frame, i}, frames} ->
          frame.(i)
          frames

        {{frame}, frames} ->
          frame.()
          frames
      end

    Blinkchain.render()
    if frames == [], do: :timer.cancel(t)

    {:noreply, %State{timer: t, frames: frames}}
  end
end
