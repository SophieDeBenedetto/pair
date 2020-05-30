defmodule PairWeb.ChallengeController do
  use PairWeb, :controller
  alias Pair.Challenges

  def index(conn, _params) do
    challenges = Challenges.get_challenges()
    render(conn, "index.html", challenges: challenges)
  end
end
