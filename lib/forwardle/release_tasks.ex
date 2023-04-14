defmodule Forwardle.ReleaseTasks do
  @moduledoc """
  One-off commands you can run on Forwardle releases.
  Run the functions from this module like this:
  `bin/forwardle eval "Forwardle.ReleaseTasks.init()"`
  If you're using the official Docker image, run them like this:
  `docker run manhtai/forwardle eval "Forwardle.ReleaseTasks.init()"`
  """

  @doc """
  Initializes the database and inserts fixtures.
  """
  def init() do
    migrate()

    Ecto.Migrator.with_repo(Forwardle.Repo, fn _ ->
      Code.eval_file(Path.join(:code.priv_dir(:forwardle), "repo/seeds.exs"))
      {:ok, :stop}
    end)
  end

  @doc """
  Runs database migrations.
  """
  def migrate do
    {:ok, _, _} = Ecto.Migrator.with_repo(Forwardle.Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  @doc """
  Rolls back database migrations to given version.
  """
  def rollback(version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(Forwardle.Repo, &Ecto.Migrator.run(&1, :down, to: version))
  end
end
