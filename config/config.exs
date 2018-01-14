# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :foo, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:foo, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :mastodon_index,
  couchdb_props: %{protocol: "http", hostname: "localhost", port: 5984},
  config_db_name: "foo",
  messages_db_name: "messages",
  http_props: [],
  servers: [{:server_name, "https://server.example/", "username", "password"},
            {:second_server, "https://second.example/", "username", "password"}]

config :elastic,
  base_url: "http://localhost:9200/"
