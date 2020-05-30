defmodule PairWeb.ChallengeLive.Index do
  use Phoenix.LiveView
  alias Pair.{Challenges, Accounts}

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
    challenge = Challenges.get_challenge(challenges, id)
    socket =
      socket
      |> assign(:challenge, challenge)
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
