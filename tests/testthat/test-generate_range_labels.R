context("generate_range_labels")

test_that("generate range labels", {
  breaks <- c(1, 3, 5)
  labels <- generate_range_labels(breaks)
  expect_equal(labels, c("2-3", "4-5"))
})

test_that("generate range labels include lowest", {
  breaks <- c(1, 3, 5)
  labels <- generate_range_labels(breaks, include.lowest = TRUE)
  expect_equal(labels, c("1-3", "4-5"))
})

test_that("generate range labels by one number", {
  breaks <- 1:3
  labels <- generate_range_labels(breaks)
  expect_equal(labels, c("2", "3"))
})
