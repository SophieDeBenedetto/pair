defmodule PairWeb.ChallengeLive.ChallengeComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent
  @languages [
    "ruby",
    "javascript",
    "python",
    "go",
    "elixir"
  ]

  def render(assigns) do
    Phoenix.View.render(PairWeb.ChallengeView, "show.html", assigns)
  end

  def mount(socket) do
    {:ok, assign(socket, :languages, @languages)}
  end

  def handle_event("update", attrs, socket) do
    message = {:updated_challenge, attrs}
    Phoenix.PubSub.broadcast(Pair.PubSub, challenge_topic(socket), message)
    {:noreply, socket}
  end

  def challenge_topic(socket) do
    "challenge:" <> to_string(socket.assigns.challenge.id)
  end
end
