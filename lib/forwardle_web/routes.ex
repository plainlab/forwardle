defmodule ForwardleWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  use ForwardleWeb, :verified_routes

  def after_sign_in_path(_conn), do: ~p"/flows"
  def user_not_authenticated_path(_conn), do: ~p"/"
end
