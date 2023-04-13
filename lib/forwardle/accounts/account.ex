defmodule Forwardle.Accounts.Account do
  @moduledoc """
  An account has one or many users
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Forwardle.{Accounts.Plan, Users.User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field(:name, :string)
    field(:plan, :string, default: Plan.free())

    has_many(:users, User)

    timestamps()
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
