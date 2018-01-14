defmodule Config do
  def couchdb_props(db) do
    base = Application.get_env(:mastodon_index, :couchdb_props) ||
      %{protocol: "http", hostname: "localhost", database: "foo", port: 5984}
    Map.put(base, :database, db)
  end

  def couchdb_props_config do
    db = Application.get_env(:mastodon_index, :config_db_name) || "mastodon_search_config"
    couchdb_props(db)
  end

  def couchdb_props_messages do
    db = Application.get_env(:mastodon_index, :messages_db_name) || "messages"
    couchdb_props(db)
  end

  def http_props do
    Application.get_env(:mastodon_index, :http_props) || []
  end
end
