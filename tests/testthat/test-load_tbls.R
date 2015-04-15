context("load_tbls")

if(!file.exists("my_db.sqlite3")) {
  db <- src_sqlite("my_db.sqlite3", create = TRUE)
  copy_nycflights13(db)
}

test_that("Basic behavior", {
  db <- src_sqlite("my_db.sqlite3")
  load_tbls(db)
  tbls <- ls(pattern = "_tbl$")
  expect_equal(tbls, c("airlines_tbl", "airports_tbl", "flights_tbl", "planes_tbl", "sqlite_stat1_tbl", "weather_tbl"))
})

test_that("Any name of db", {
  my_db <- src_sqlite("my_db.sqlite3")
  load_tbls(my_db)
  tbls <- ls(pattern = "_tbl$")
  expect_equal(tbls, c("airlines_tbl", "airports_tbl", "flights_tbl", "planes_tbl", "sqlite_stat1_tbl", "weather_tbl"))
})

test_that("Reload tables", {
  db <- src_sqlite("my_db.sqlite3")
  load_tbls(db)
  load_tbls(db)
  tbls <- ls(pattern = "_tbl$")
  expect_equal(tbls, c("airlines_tbl", "airports_tbl", "flights_tbl", "planes_tbl", "sqlite_stat1_tbl", "weather_tbl"))
})
