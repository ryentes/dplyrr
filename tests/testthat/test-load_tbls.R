context("load_tbls")

if(!file.exists("my_db.sqlite3")) {
  db <- src_sqlite("my_db.sqlite3", create = TRUE)
  copy_nycflights13(db)
}

test_that("Basic behavior", {
  db <- src_sqlite("my_db.sqlite3")
  load_tbls(db, verbose = FALSE)
  tbls <- ls(pattern = "_tbl$")
  expect_equal(tbls, c("airlines_tbl", "airports_tbl", "flights_tbl", "planes_tbl", "sqlite_stat1_tbl", "weather_tbl"))
})

test_that("Any name of db", {
  my_db <- src_sqlite("my_db.sqlite3")
  load_tbls(my_db, verbose = FALSE)
  tbls <- ls(pattern = "_tbl$")
  expect_equal(tbls, c("airlines_tbl", "airports_tbl", "flights_tbl", "planes_tbl", "sqlite_stat1_tbl", "weather_tbl"))
})

test_that("Reload tables", {
  db <- src_sqlite("my_db.sqlite3")
  load_tbls(db, verbose = FALSE)
  with_mock(
    message = function(...) stop(),
    load_tbls(db)
  )
})

test_that("force", {
  db <- src_sqlite("my_db.sqlite3")
  load_tbls(db, verbose = FALSE)
  expect_message(load_tbls(db, force = TRUE), "Loading: ")
})
