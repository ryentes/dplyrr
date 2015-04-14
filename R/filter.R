#' Improved filter for tbl_sql which adds parentheses
#'
filter_.tbl_sql <- function(.data, ..., .dots) {
  .dots <- Map(function(.dot) {
    sprintf("(%s)", deparse(.dot$expr))
  }, .dots)
  dots <- lazyeval::all_dots(.dots, ...)
  input <- partial_eval(dots, .data)
  update(.data, where = c(.data$where, input))
}
