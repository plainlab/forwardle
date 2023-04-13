defmodule Forwardle.Accounts.Role do
  @moduledoc """
  Define role of user in an account
  """

  @member "member"
  @admin "admin"

  def member, do: @member
  def admin, do: @admin
end
