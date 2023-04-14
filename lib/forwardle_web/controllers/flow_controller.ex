defmodule ForwardleWeb.FlowController do
  use ForwardleWeb, :controller

  def list(conn, _params) do
    render(conn, :list)
  end
end
