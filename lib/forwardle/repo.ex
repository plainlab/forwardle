defmodule Forwardle.Repo do
  use Ecto.Repo,
    otp_app: :forwardle,
    adapter: Ecto.Adapters.Postgres
end
