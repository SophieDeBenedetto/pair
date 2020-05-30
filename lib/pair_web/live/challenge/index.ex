defmodule PairWeb.ChallengeLive.Index do
  use Phoenix.LiveView
  alias Pair.{Challenges, Accounts}

  def render(assigns) do
    Phoenix.View.render(PairWeb.ChallengeView, "index.html", assigns)
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    challenge = Challenges.get_challenge_by_id(id)
    socket =
      socket
      |> assign(:challenge, challenge)
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def mount(%{"id" => id}, %{"user_token" => user_token} = session, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)
    challenges = Challenges.get_challenges()
    socket =
      socket
      |> assign(:challenges, challenges)
      |> assign(:current_user, current_user)
    {:ok, socket}
  end

  def mount(_params, %{"user_token" => user_token} = session, %{assigns: %{live_action: :index}} = socket) do
    challenges = Challenges.get_challenges()
    current_user = Accounts.get_user_by_session_token(user_token)
    socket =
      socket
      |> assign(:challenges, challenges)
      |> assign(:challenge, nil)
      |> assign(:current_user, current_user)
    {:ok, socket}
  end
end
