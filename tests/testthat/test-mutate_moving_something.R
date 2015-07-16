context("mutate_moving_something")

srcs <- temp_srcs("postgres")
df <- data.frame(x = 1:5)
df2 <- data.frame(group=LETTERS, value=1:(26*3))
tbls <- dplyr:::temp_load(srcs, list(df=df, df2=df2))
temp_tbl <- tbls$postgres$df
temp_tbl2 <- tbls$postgres$df2

if(!is.null(tbls$postgres)) {
  
  test_that("using moving_mean in mutate", {
    q <- temp_tbl %>% 
      mutate(y=moving_mean(x, 1))
    result <- q %>% collect
    expect_equal(result$y, c(1.5, 2.0, 3.0, 4.0, 4.5))
  })
  
  test_that("using moving_max in mutate", {
    q <- temp_tbl %>% 
      mutate(y=moving_max(x, 1))
    result <- q %>% collect
    expect_equal(result$y, c(2, 3, 4, 5, 5))
  })
  
  test_that("using moving_min in mutate", {
    q <- temp_tbl %>% 
      mutate(y=moving_min(x, 1))
    result <- q %>% collect
    expect_equal(result$y, c(1, 1, 2, 3, 4))
  })
  
  test_that("using moving_sum in mutate", {
    q <- temp_tbl %>% 
      mutate(y=moving_sum(x, 1))
    result <- q %>% collect
    expect_equal(result$y, c(3, 6, 9, 12, 9))
  })
  
  test_that("with other window function", {
    q <- temp_tbl %>% 
      mutate(m=mean(x)) %>%
      mutate(y=moving_mean(x, 1))
    result <- q %>% collect
    expect_equal(result$m, c(3, 3, 3, 3, 3))
    expect_equal(result$y, c(1.5, 2.0, 3.0, 4.0, 4.5))
  })

  test_that("with other window function2", {
    q <- temp_tbl %>% 
      mutate(y=moving_mean(x, 1)) %>%
      mutate(m=mean(x)) 
    result <- q %>% collect
    expect_equal(result$m, c(3, 3, 3, 3, 3))
    expect_equal(result$y, c(1.5, 2.0, 3.0, 4.0, 4.5))
  })

  test_that("PRECEDING and FOLLOWING are different", {
    q <- temp_tbl %>% 
      mutate(y=moving_mean(x, 1, 2))
    result <- q %>% collect
    expect_equal(result$y, c(2.0, 2.5, 3.5, 4.0, 4.5))
  })

  test_that("simultaneously", {
    q <- temp_tbl %>% 
      mutate(y=moving_mean(x, 1), z=moving_mean(x, 2))
    result <- q %>% collect
    expect_equal(result$y, c(1.5, 2.0, 3.0, 4.0, 4.5))
    expect_equal(result$z, c(2.0, 2.5, 3.0, 3.5, 4.0))
  })

  test_that("with summarise", {
    q <- temp_tbl2 %>%
      group_by(group) %>%
      arrange(group) %>%
      summarise(total = sum(value)) %>%
      mutate(y=moving_mean(total, 1))
    result <- q %>% collect
    expect_equal(result$y[1:6], c(82.5, 84, 87, 90, 93, 96))
  })
  
}
