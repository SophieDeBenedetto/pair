defmodule PairWeb.ChallengeLive.Index do
  use Phoenix.LiveView
  alias Pair.{Challenges, Accounts}
  alias PairWeb.Endpoint

  def render(assigns) do
    Phoenix.View.render(PairWeb.ChallengeView, "index.html", assigns)
  end

  def mount(_params, %{"user_token" => user_token} = session, socket) do
    challenges = Challenges.get_challenges()
    current_user = Accounts.get_user_by_session_token(user_token)
    socket =
      socket
      |> assign(:challenges, challenges)
      |> assign(:challenge, nil)
      |> assign(:current_user, current_user)
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, %{assigns: %{challenges: challenges}} = socket) do
    challenge = Challenges.get_challenge_by_id(id)
    Phoenix.PubSub.subscribe(Pair.PubSub, "challenge:#{challenge.id}")
    {:noreply, assign(socket, :challenge, challenge)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_info({:updated_challenge, attrs}, socket) do
    # could avoid DB query for challenge by updated list here
    # and fetching from cached list in handle_params/3
    {:ok, challenge} = Challenges.update_challenge(socket.assigns.challenge, attrs)
    {:noreply, assign(socket, :challenge, challenge)}
  end
end
