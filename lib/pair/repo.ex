defmodule Pair.Repo do
  use Ecto.Repo,
    otp_app: :pair,
    adapter: Ecto.Adapters.Postgres
end
