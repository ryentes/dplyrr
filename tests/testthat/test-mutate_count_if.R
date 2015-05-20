context("mutate_count_if")

srcs <- temp_srcs("sqlite", "postgres")
df <- data.frame(class = c("A", "A", "A", "B", "B", "B"), x = 1:6)
tbls <- dplyr:::temp_load(srcs, list(df=df))

temp_tbl <- tbls$sqlite$df

test_that("using count_if in mutate for SQLite", {
  q <- temp_tbl %>%
    mutate(y = count_if(x %% 2 == 0), z = n_if(x %% 2 == 1))
  result <- q %>% collect
  expect_equal(result$y, c(3))
  expect_equal(result$z, c(3))
})

if(!is.null(tbls$postgres)) {
  temp_tbl <- tbls$postgres$df
  
test_that("using count_if in mutate for PostgreSQL", {
    q <- temp_tbl %>%
      mutate(y = count_if(x %% 2 == 0), z = n_if(x %% 2 == 1))
    result <- q %>% collect
    expect_equal(result$y, c(3, 3, 3, 3, 3, 3))
    expect_equal(result$z, c(3, 3, 3, 3, 3, 3))
  })

  test_that("using count_if in mutate with group_by for PostgreSQL", {
    q <- temp_tbl %>%
      group_by(class) %>%
      mutate(y = count_if(x %% 2 == 0), z = n_if(x %% 2 == 1)) %>%
      arrange(class)
    result <- q %>% collect
    expect_equal(result$y, c(1, 1, 1, 2, 2, 2))
    expect_equal(result$z, c(2, 2, 2, 1, 1, 1))
  })
    
}
