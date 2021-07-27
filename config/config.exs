import Config

config :gaki_bot, GakiBot.Repo,
  database: "gaki_bot_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :gaki_bot, GakiBot.Repo,
  database: "gaki_bot_repo",
  username: "ashida",
  password: "ashida",
  hostname: "localhost"

config :gaki_bot,
  ecto_repos: [GakiBot.Repo]

config :gaki_bot,
  admins: {:system, "ADMINS"}

config :ex_gram,
  token: {:system, "BOT_TOKEN"}

config :logger,
  level: :debug,
  truncate: :infinity,
  backends: [{LoggerFileBackend, :debug}, {LoggerFileBackend, :error}]

config :logger, :debug,
  path: "log/debug.log",
  level: :debug,
  format: "$dateT$timeZ [$level] $message\n"

config :logger, :error,
  path: "log/error.log",
  level: :error,
  format: "$dateT$timeZ [$level] $message\n"
