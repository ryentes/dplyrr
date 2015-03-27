context("load_tbls")

test_that("Basic behavior", {
  if(!file.exists("my_db.sqlite3")) {
    db <- src_sqlite("my_db.sqlite3", create = TRUE)
    copy_nycflights13(db)
  }
  db <- src_sqlite("my_db.sqlite3")
  load_tbls(db)
  tbls <- ls(pattern = "_tbl$")
  expect_equal(tbls, c("airlines_tbl", "airports_tbl", "flights_tbl", "planes_tbl", "sqlite_stat1_tbl", "weather_tbl"))
})
