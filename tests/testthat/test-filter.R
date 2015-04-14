context("filter")

if(!file.exists("my_db.sqlite3")) {
  db <- src_sqlite("my_db.sqlite3", create = TRUE)
  copy_nycflights13(db)
}

test_that("Basic behavior", {
  db <- src_sqlite("my_db.sqlite3")
  flights_tbl <- tbl(db, "flights")
  q <- flights_tbl %>%
    filter(month == 1) %>%
    filter(air_time > 200 || air_time < 100)
  data <- q %>% collect
  expect_equal(nrow(data), 14482)
})
