defmodule Zuri.Repo do
  use Ecto.Repo,
    otp_app: :zuri,
    adapter: Ecto.Adapters.Postgres
end
