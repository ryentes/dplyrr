context("mutate_cut")

srcs <- temp_srcs("sqlite", "postgres")
df <- data.frame(x = 1:5)
tbls <- dplyr:::temp_load(srcs, list(df=df))

test_that("using cut in mutate for sqlite", {
  temp_tbl <- tbls$sqlite$df
  q <- temp_tbl %>% 
    mutate(y=cut(x, c(1, 3, 5)))
  result <- q %>% collect
  expect_equal(result$y, c(NA, "(1,3]", "(1,3]", "(3,5]", "(3,5]"))
})
  
test_that("using cut in mutate for postgres", {
  if(!is.null(tbls$postgres)) {
    temp_tbl <- tbls$postgres$df
    q <- temp_tbl %>% 
      mutate(y=cut(x, c(1, 3, 5)))
    result <- q %>% collect
    expect_equal(result$y, c(NA, "(1,3]", "(1,3]", "(3,5]", "(3,5]"))
  }
})
