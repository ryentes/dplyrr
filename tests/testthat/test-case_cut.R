context("case_cut")

if(!file.exists("my_db.sqlite3")) {
  db <- src_sqlite("my_db.sqlite3", create = TRUE)
  copy_nycflights13(db)
}

test_that("Basic behavior", {
  db <- src_sqlite("my_db.sqlite3")
  flights_tbl <- tbl(db, "flights")

  q <- flights_tbl %>% 
    case_cut(air_time_cut=air_time, breaks=c(20, 82, 129, 192, 695))
  data <- q %>% collect
  
  expect_equal(data$air_time_cut[1:3], 
               c("(192,695]", "(192,695]", "(129,192]"))
})
