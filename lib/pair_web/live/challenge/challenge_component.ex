defmodule PairWeb.ChallengeLive.ChallengeComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(PairWeb.ChallengeView, "show.html", assigns)
  end
end
