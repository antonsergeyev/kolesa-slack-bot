defmodule Km do
  use Application

 def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Km.Bot, [Application.get_env(:km, :slack_api_key)]),
      worker(Agent, [fn -> %{} end, [name: :cache]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Km.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
