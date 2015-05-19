context("mutate_first_value")

srcs <- temp_srcs("postgres")
df <- data.frame(a = LETTERS[1:3], x = 1:6, y = 16:11)
tbls <- dplyr:::temp_load(srcs, list(df=df))
temp_tbl <- tbls$postgres$df

if(!is.null(tbls$postgres)) {
  
  test_that("using first_value in mutate", {
    q <- temp_tbl %>%
      group_by(a) %>%
      mutate(z = first_value(x))
    result <- q %>% collect
    expect_equal(result$z, c(1, 1, 2, 2, 3, 3))
  })

  test_that("value and order_by are different", {
    q <- temp_tbl %>%
      group_by(a) %>%
      mutate(z = first_value(y, x))
    result <- q %>% collect
    expect_equal(result$z, c(16, 16, 15, 15, 14, 14))
  })

  test_that("order_by desc", {
    q <- temp_tbl %>%
      group_by(a) %>%
      mutate(z = first_value(y, desc(x)))
    result <- q %>% collect
    expect_equal(result$z, c(13, 13, 12, 12, 11, 11))
  })
  
  test_that("with rank()", {
    q <- temp_tbl %>% 
      group_by(a) %>%
      mutate(r=rank(x)) %>%
      mutate(z=first_value(x))
    result <- q %>% collect
    expect_equal(result$r, c(1, 2, 1, 2, 1, 2))
    expect_equal(result$z, c(1, 1, 2, 2, 3, 3))
  })
  
  test_that("with rank() 2", {
    q <- temp_tbl %>% 
      group_by(a) %>%
      mutate(z=first_value(x)) %>%
      mutate(r=rank(x)) 
    result <- q %>% collect
    expect_equal(result$r, c(1, 2, 1, 2, 1, 2))
    expect_equal(result$z, c(1, 1, 2, 2, 3, 3))
  })
  
  test_that("simultaneously", {
    q <- temp_tbl %>% 
      group_by(a) %>%
      mutate(z=first_value(x), w=first_value(y))
    result <- q %>% collect
    expect_equal(result$z, c(1, 1, 2, 2, 3, 3))
    expect_equal(result$w, c(13, 13, 12, 12, 11, 11))
  })
  
}
