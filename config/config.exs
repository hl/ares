import Config

config :ares, CubDB,
  data_dir: "data",
  name: Ares.Repo

import_config "#{config_env()}.exs"
