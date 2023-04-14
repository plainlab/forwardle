defmodule ForwardleWeb.PageController do
  use ForwardleWeb, :controller

  def home(conn, _params) do
    case Pow.Plug.current_user(conn) do
      nil -> render(conn, :home, layout: false)
      _ -> redirect(conn, to: "/flows")
    end
  end
end
