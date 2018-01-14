defmodule MastodonClient do

  # Streaming api: https://github.com/edgurgel/httpoison/issues/72

  defmodule Credentials do
    defstruct url: nil, token: nil
  end

  defp request_new_id(url) do
#    Tesla.request(url: "#{url}api/v1/apps", method: :post,
#      query: [redirect_uris: "urn:ietf:wg:oauth:2.0:oob",
#              client_name: "mastodon-ex",
#              scopes: "read write follow"])
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
      HTTPoison.request(:post, "#{url}api/v1/apps",
        {:form, [{"redirect_uris", "urn:ietf:wg:oauth:2.0:oob"},
                 {"client_name", "mastodon-ex"},
                 {"scopes", "read write follow"}]},
        [], Config.http_props())
    %{"client_id" => client_id, "client_secret" => client_secret} = Poison.decode!(body)
    {:ok, _} = Couchdb.Connector.create(Config.couchdb_props_config(),
      %{client_id: client_id, client_secret: client_secret},
      make_id_couchdb_key(url))
    [client_id, client_secret]
  end

  defp make_id_couchdb_key(url) do
    "server_id-" <> CouchdbUtils.encode_name(url)
  end

  def find_or_create_id(url) do
    id = make_id_couchdb_key(url)
    case Couchdb.Connector.get(Config.couchdb_props_config(), id) do
      {:ok, %{"client_id" => client_id, "client_secret" => client_secret}} ->
        [client_id, client_secret]
      {:error, %{"error" => "not_found", "reason" => "missing"}} ->
        request_new_id(url)
    end
  end

  def login(url, username, password) do
    [client_id, client_secret] = find_or_create_id(url)
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
      HTTPoison.request(:post, "#{url}oauth/token",
        {:form, [{"client_id", client_id},
                 {"client_secret", client_secret},
                 {"grant_type", "password"},
                 {"username", username},
                 {"password", password},
                 {"scope", "read write follow"}]},
        [], Config.http_props())
    %{"access_token" => access_token} = Poison.decode!(body)
    %Credentials{url: url, token: access_token}
  end

  def load_stream(cred, name, pid) do
    HTTPoison.request!(:get, cred.url <> name,
      "",
      [{"Accept", "application/json"},
       {"Authorization", "Bearer " <> cred.token}],
      Config.http_props() ++ [{:recv_timeout, 6000000},
                              {:stream_to, pid}])
  end
end
