defmodule MastodonIndex.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    v = Application.get_env(:mastodon_index, :servers)
    children = Enum.map(v, fn({id, url, user, password}) ->
      Supervisor.child_spec({MessageConnection, [url, user, password]}, id: id)
    end)
    Supervisor.init(children, strategy: :one_for_one)
  end
end
