context("moving_average")

TEST <- FALSE

if(TEST) {
  test_that("Basic behavior", {
    db <- src_postgres()
    account_tbl <- tbl(db, "account")
    q <- account_tbl %>% 
      filter(between(register_datetime, "2010-09-01", "2010-10-01")) %>%
      count(date=date_trunc("days", register_datetime)) %>%
      moving_average(moving_average=n(3))
    data <- q %>% collect
    expect_equal(data$moving_average[1:2], c(73.5, 71.4))
  })  
}
