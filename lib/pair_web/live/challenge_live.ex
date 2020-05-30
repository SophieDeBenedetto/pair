defmodule PairWeb.ChallengeLive do
  use Phoenix.LiveView
  alias Pair.{Challenges, Accounts}

  def render(assigns) do
    Phoenix.View.render(PairWeb.ChallengeView, "show.html", assigns)
  end

  def mount(%{"id" => id}, %{"user_token" => user_token} = session, socket) do
    challenge = Challenges.get_challenge_by_id(id)
    current_user = Accounts.get_user_by_session_token(user_token)
    socket =
      socket
      |> assign(:challenge, challenge)
      |> assign(:current_user, current_user)
    {:ok, socket}
  end
end
