defmodule MastodonIndex do
  use Application

  def start(type, args) do
    IO.puts "Starting application. type=#{inspect(type)}, args=#{inspect(args)}"
    MastodonIndex.Supervisor.start_link(name: MastodonIndex.Supervisor)
  end
end
