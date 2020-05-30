defmodule PairWeb.PageController do
  use PairWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
