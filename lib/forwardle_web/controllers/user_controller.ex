defmodule ForwardleWeb.UserController do
  use ForwardleWeb, :controller

  alias Forwardle.Users

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, _params) do
    user = Pow.Plug.current_user(conn)
    # Non-cached version
    user = Users.find_user_by_id(user.id)
    render(conn, "show.html", user: user)
  end
end
