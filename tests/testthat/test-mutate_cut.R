context("mutate_cut")

srcs <- temp_srcs("sqlite", "postgres")
df <- data.frame(x = 1:5)
tbls <- dplyr:::temp_load(srcs, list(df=df))
temp_tbl <- tbls$sqlite$df

test_that("using cut in mutate for sqlite", {
  q <- temp_tbl %>% 
    mutate(y=cut(x, c(1, 3, 5)))
  result <- q %>% collect
  expect_equal(result$y, c(NA, "(1,3]", "(1,3]", "(3,5]", "(3,5]"))
})

test_that("using Inf for sqlite", {
  q <- temp_tbl %>% 
    mutate(y=cut(x, c(1, 3, Inf)))
  result <- q %>% collect
  expect_equal(result$y, c(NA, "(1,3]", "(1,3]", "(3,Inf]", "(3,Inf]"))
})

test_that("using labels for sqlite", {
  q <- temp_tbl %>% 
    mutate(y=cut(x, c(1, 3, 5), labels=c("2-3", "4-5")))
  result <- q %>% collect
  expect_equal(result$y, c(NA, "2-3", "2-3", "4-5", "4-5"))
})

test_that("calculation in x for sqlite", {
  q <- temp_tbl %>% 
    mutate(y=cut(x / 2, c(1, 3, 5)))
  result <- q %>% collect
  expect_equal(result$y, c(NA, NA, "(1,3]", "(1,3]", "(1,3]"))
})

test_that("using cut in mutate with labels shortcut for sqlite", {
  q <- temp_tbl %>% 
    mutate(y=cut(x, c(1, 3, 5), labels="-"))
  result <- q %>% collect
  expect_equal(result$y, c(NA, "2-3", "2-3", "4-5", "4-5"))
})

if(!is.null(tbls$postgres)) {
  temp_tbl <- tbls$postgres$df

  test_that("using cut in mutate for postgres", {
    q <- temp_tbl %>% 
      mutate(y=cut(x, c(1, 3, 5)))
    result <- q %>% collect
    expect_equal(result$y, c(NA, "(1,3]", "(1,3]", "(3,5]", "(3,5]"))
  })

  test_that("using Inf for postgres", {
    q <- temp_tbl %>% 
      mutate(y=cut(x, c(1, 3, Inf)))
    result <- q %>% collect
    expect_equal(result$y, c(NA, "(1,3]", "(1,3]", "(3,Inf]", "(3,Inf]"))
  })
  
  test_that("using labels for sqlite", {
    q <- temp_tbl %>% 
      mutate(y=cut(x, c(1, 3, 5), labels=c("2-3", "4-5")))
    result <- q %>% collect
    expect_equal(result$y, c(NA, "2-3", "2-3", "4-5", "4-5"))
  })
  
  test_that("calculation in x for postgres", {
    q <- temp_tbl %>% 
      mutate(y=cut(x / 2, c(1, 3, 5)))
    result <- q %>% collect
    expect_equal(result$y, c(NA, NA, "(1,3]", "(1,3]", "(1,3]"))
  })

  test_that("using cut in mutate with labels shortcut for postgres", {
    q <- temp_tbl %>% 
      mutate(y=cut(x, c(1, 3, 5), labels="-"))
    result <- q %>% collect
    expect_equal(result$y, c(NA, "2-3", "2-3", "4-5", "4-5"))
  })
  
}
