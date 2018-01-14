defmodule MessageConnection do
  use GenServer

  defmodule ConnectionState do
    defstruct url: nil, cred: nil
  end

  def start_link([url, user, password]) do
    GenServer.start_link(__MODULE__, [url, user, password], [])
  end

  def init([url, user, password]) do
    IO.puts "Starting MessageConnection for url: #{url}"
    cred = MastodonClient.login(url, user, password)
    MastodonClient.load_stream(cred, "api/v1/streaming/public/local", self())
    {:ok, %ConnectionState{url: url, cred: cred}}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: content}, state) do
    if String.starts_with?(content, "data: ") do
      json = Poison.decode!(String.slice(content, 6..-1))
      save_message_to_db(json)
    end
    {:noreply, state}
  end

  def handle_info(%HTTPoison.AsyncHeaders{headers: _headers}, state) do
    {:noreply, state}
  end

  def handle_info(%HTTPoison.AsyncStatus{code: 200}, state) do
    {:noreply, state}
  end

  def handle_info(%HTTPoison.AsyncStatus{code: code}, _state) do
    raise "Unexpected code: #{inspect(code)}"
  end

  def handle_info(v, state) do
    IO.puts "Unexpected info: #{inspect(v)}"
    {:noreply, state}
  end

  defp save_message_to_db(msg) do
    IO.puts "Saving message: #{msg["uri"]}"
    {:ok, _} = Couchdb.Connector.create(Config.couchdb_props_messages(),
      %{original: msg},
      [CouchdbUtils.encode_name(msg["uri"])])
  end

end
