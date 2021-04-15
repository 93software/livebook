import Config
require Logger

config :livebook, LivebookWeb.Endpoint,
  secret_key_base:
    Livebook.Config.secret!("LIVEBOOK_SECRET_KEY_BASE") ||
      Base.encode64(:crypto.strong_rand_bytes(48))

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

if password = Livebook.Config.password!("LIVEBOOK_PASSWORD") do
  config :livebook, authentication_mode: :password, password: password
else
  config :livebook, token: Livebook.Utils.random_id()
end

if port = Livebook.Config.port!("LIVEBOOK_PORT") do
  config :livebook, LivebookWeb.Endpoint, http: [port: port]
end
