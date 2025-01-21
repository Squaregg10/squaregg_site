defmodule SquareggSite.Repo do
  use Ecto.Repo,
    otp_app: :squaregg_site,
    adapter: Ecto.Adapters.Postgres
end
