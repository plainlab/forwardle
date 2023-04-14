defmodule Forwardle.Users.User do
  @moduledoc """
  User repo
  """
  import Ecto.Changeset

  use Ecto.Schema
  use Pow.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  alias Forwardle.Accounts.{Account, Role}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:email_confirmation_token, :string)
    field(:email_confirmed_at, :utc_datetime)
    field(:unconfirmed_email, :string)

    field(:role, :string, default: Role.member())
    belongs_to(:account, Account, type: :binary_id)

    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> cast(attrs, [:account_id, :role])
    |> pow_extension_changeset(attrs)
  end
end
