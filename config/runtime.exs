import Config

# Configure the type of names used for distribution and the node name.
# By default a random short name is used.
# config :livebook, :node, {:shortnames, "livebook"}
# config :livebook, :node, {:longnames, :"livebook@127.0.0.1"}

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.

if System.get_env("EXPOSE_APP") == "true" do
  config :livebook, LivebookWeb.Endpoint,
    http: [:inet6, port: System.fetch_env!("PORT") |> String.to_integer()],
    url: [scheme: "https", host: System.fetch_env!("HOST"), port: 443],
    server: true
else
  config :livebook, LivebookWeb.Endpoint, http: [ip: {127, 0, 0, 1}, port: 8080]
end

if config_env() == :prod do
  # We don't need persistent session, so it's fine to just
  # generate a new key everytime the app starts
  secret_key_base = :crypto.strong_rand_bytes(48) |> Base.encode64()

  config :livebook, LivebookWeb.Endpoint, secret_key_base: secret_key_base
end
