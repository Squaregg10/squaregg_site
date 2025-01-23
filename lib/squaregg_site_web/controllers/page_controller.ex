defmodule SquareggSiteWeb.PageController do
  use SquareggSiteWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
