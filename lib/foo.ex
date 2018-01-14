defmodule Foo do
  use GenServer

  def start_link([url, username, password]) do
    GenServer.start_link(__MODULE__, [url, username, password], [])
  end

  def init([url, username, password]) do
    IO.puts "Starting Foo, url=#{inspect(url)}, username=#{inspect(username)}, password=#{inspect(password)}"
    {:ok, nil}
  end
end
