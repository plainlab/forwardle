defmodule ForwardleWeb.RegistrationController do
  use ForwardleWeb, :controller

  alias Forwardle.Accounts
  alias Forwardle.Accounts.Role

  def new(conn, _params) do
    changeset = Pow.Plug.change_user(conn)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> user_with_account_transaction(user_params)
    |> Forwardle.Repo.transaction()
    |> case do
      {:ok, %{conn: conn}} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> redirect(to: "/")

      {:error, _op, changeset, _changes} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @spec user_with_account_transaction(Conn.t(), map()) :: Ecto.Multi.t()
  def user_with_account_transaction(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:account, fn _repo, %{} ->
      Accounts.create_account(%{name: "My account"})
    end)
    |> Ecto.Multi.run(:conn, fn _repo, %{account: account} ->
      user_params =
        Enum.into(params, %{
          "account_id" => account.id,
          "role" => Role.admin()
        })

      case Pow.Plug.create_user(conn, user_params) do
        {:ok, user, conn} ->
          conn =
            conn
            |> put_session(:current_user_id, user.id)
            |> configure_session(renew: true)

          {:ok, conn}

        {:error, changeset, _conn} ->
          {:error, changeset}
      end
    end)
  end
end
