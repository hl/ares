ExUnit.start()

ExUnit.after_suite(fn _results ->
  cub_db_config = Application.get_env(:ares, CubDB)
  CubDB.clear(cub_db_config[:name])
end)
