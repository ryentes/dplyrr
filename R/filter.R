#' Improved filter for tbl_sql which adds parentheses
#'
filter_.tbl_sql <- function(.data, ..., .dots) {
  .dots <- Map(function(.dot) {
    expr <- as.expression(sprintf("(%s)", deparse(.dot$expr)))
    .dot$expr <- lazyeval::lazy_dots(expr)
    .dot
  }, .dots)
  dots <- lazyeval::all_dots(.dots, ...)
  input <- partial_eval(dots, .data)
  update(.data, where = c(.data$where, input))
}
