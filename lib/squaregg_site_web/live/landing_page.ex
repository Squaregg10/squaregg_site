defmodule SquareggSiteWeb.LandingPage do
  use SquareggSiteWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: SquareggSite.Score.subscribe()

    recent_scores = SquareggSite.Score.get_recent_scores()
    chat = SquareggSite.Chat.get_chat()

    socket =
      socket
      |> assign(:user, "guest" <> Integer.to_string(:rand.uniform(9_999_999)))
      |> stream(:recent_scores, recent_scores)
      |> stream(:chat, chat)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>Something is here</div>
    <div>{@user}</div>

    <div class="flex justify-around">
      <div>
        <button phx-click="submit-score" class="bg-yellow-200 p-2 rounded">Submit a score</button>
        <h2 class="font-bold text-2xl">Recent Scores</h2>
        <div id="recent-score-container" phx-update="stream" class="flex flex-col gap-2">
          <div :for={{id, score} <- @streams.recent_scores} id={id} class="bg-gray-500 p-2">
            <div>id: {id}</div>
            <div>user: {score.user}</div>
            <div>score: {score.score}</div>
            <div>{score.inserted_at}</div>
          </div>
        </div>
      </div>

      <div>
        <h2 class="font-bold text-2xl">Chat</h2>
        <div id="chat-container" phx-update="stream" class="flex flex-col gap-2">
          <div :for={{id, message} <- @streams.chat} id={id} class="bg-slate-200 p-2">
            <div>id: {id}</div>
            <div>user: {message.user}</div>
            <div>message: {message.message}</div>
            <div>{message.inserted_at}</div>
          </div>
        </div>

        <form>
          <input class="bg-gray-200 p-2"/>
          <button>Send</button>
        </form>
      </div>
    </div>
    """
  end

  def handle_event("submit-score", _thingos, socket) do
    SquareggSite.Score.insert(socket.assigns.user, :rand.uniform(100))
    {:noreply, socket}
  end

  def handle_info({:insert, score}, socket) do
    {:noreply,
     socket
     |> stream_insert(:recent_scores, score, at: 0, limit: 5)
     |> put_flash(:info, "#{socket.assigns.user} uploaded a new score")}
  end
end
