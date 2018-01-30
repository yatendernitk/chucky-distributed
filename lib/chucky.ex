defmodule Chucky do
  use Application
  require Logger

  @moduledoc """
  Documentation for Chucky.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Chucky.hello
      :world

  """
  def hello do
    :world
  end

  def start(type, _args) do
    import Supervisor.Spec
    IO.inspect type
    children = [
      worker(Chucky.Server, [])
    ]
    case type do
      :normal ->
        Logger.info("Application is started on #{node()}")

      {:takeover, old_node} ->
        Logger.info("#{node()} is taking over #{old_node}")

      {:failover, old_node} ->
        Logger.info("#{old_node} is failing over to #{node()}")
    end

    opts = [strategy: :one_for_one, name: {:global, Chucky.Supervisor}]
    Supervisor.start_link(children, opts)
  end

  def fact do
    Chucky.Server.fact()
  end
end
