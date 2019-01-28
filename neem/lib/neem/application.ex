defmodule Neem.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    start_cowboy()
    children = []

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Neem.Supervisor]
    Supervisor.start_link(children, opts)
  end
  
  def start_cowboy() do
    route1 = {"/", Neem.Web.PageHandler, :home} ①
    route2 = {"/about", Neem.Web.PageHandler, :about}
    route3 = {"/contact", Neem.Web.PageHandler, :contact}
    route4 = {:_, Neem.Web.PageHandler, :not_found}
    route5 = {"/images[...]", :cowboy_static, {:priv_dir, :neem, "static/images"}}
    routes = [{:_, [route1, route2, route3, route4, route5]}]
    dispatch = :cowboy_router.compile(routes)
    opts = [port: 8080]
    env = [dispatch: dispatch]
    
    case :cowboy.start_http(:http, 10, opts, [env: env]) do
      {:ok, _pid} -> IO.puts "Cowboy is running, goto localhost:5000"
      _ -> IO.puts "An error occured while starting cowboy"
    end
  end
end
