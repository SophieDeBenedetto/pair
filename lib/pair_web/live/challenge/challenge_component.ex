defmodule PairWeb.ChallengeLive.ChallengeComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent
  alias PairWeb.ChallengePresence

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

  def update(%{current_user: current_user} = assigns, socket) do
    case ChallengePresence.get_by_key(challenge_topic(assigns), current_user.id) do
      [] ->
        {:ok, _} =
          ChallengePresence.track(self(), challenge_topic(assigns), current_user.id, %{
            email: current_user.email,
            typing: false
          })

      _ ->
        :noop
    end
    IO.puts "UPDATING..."
    users =
      ChallengePresence.list(challenge_topic(assigns))
      |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
      end)
    IO.inspect users
    socket =
      socket
      |> assign(assigns)
      |> assign(:users, users)
    IO.inspect socket.assigns
    {:ok, socket}
  end

  def handle_event("update", %{"body" => body} = attrs, socket) do
    ChallengePresence.update(
      self(),
      challenge_topic(socket.assigns),
      socket.assigns.current_user.id,
      %{
        email: socket.assigns.current_user.email,
        typing: true
      }
    )

    message = {:updated_challenge, attrs}
    Phoenix.PubSub.broadcast(Pair.PubSub, challenge_topic(socket.assigns), message)
    {:noreply, socket}
  end

  def handle_event("update", attrs, socket) do
    message = {:updated_challenge, attrs}
    Phoenix.PubSub.broadcast(Pair.PubSub, challenge_topic(socket.assigns), message)
    {:noreply, socket}
  end

  def handle_event(
        "stop_typing",
        _value,
        %{assigns: %{challenge: challenge, current_user: current_user}} = socket
      ) do
    ChallengePresence.update(
      self(),
      challenge_topic(socket.assigns),
      socket.assigns.current_user.id,
      %{
        email: socket.assigns.current_user.email,
        typing: false
      }
    )

    users =
      ChallengePresence.list(challenge_topic(socket.assigns))
      |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
      end)

    {:noreply, assign(socket, :users, users)}
  end

  def challenge_topic(assigns) do
    "challenge:" <> to_string(assigns.challenge.id)
  end
end
