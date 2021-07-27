defmodule GakiBot.Repo do
  use Ecto.Repo,
    otp_app: :gaki_bot,
    adapter: Ecto.Adapters.Postgres
end
