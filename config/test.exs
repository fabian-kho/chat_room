import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chat_room, ChatRoomWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "mC0HZo3CCP7eB1Md6/lvTCA3vJPP8BWud4wmbN+R6djNQtfd8PRJId1uov2vaSoD",
  server: false

# In test we don't send emails.
config :chat_room, ChatRoom.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
