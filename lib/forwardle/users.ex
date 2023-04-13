defmodule Forwardle.Users do
  @moduledoc """
  Users context
  """
  import Ecto.Query

  alias Forwardle.Repo
  alias Forwardle.Users.User

  @spec find_user_by_email(binary()) :: User.t() | nil
  def find_user_by_email(email) do
    User
    |> where(email: ^email)
    |> Repo.one()
  end

  @spec find_user_by_id(binary()) :: User.t() | nil
  def find_user_by_id(id) do
    User
    |> where(id: ^id)
    |> Repo.one()
  end
end
