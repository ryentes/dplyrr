#' Improved filter for tbl_sql which adds parentheses
#'
filter_.tbl_sql <- function(.data, ..., .dots) {
  dots <- lazyeval::all_dots(.dots, ...)
  dots <- Map(function(dot) {
    expr <- sprintf("(%s)", deparse(dot$expr))
    env <- dot$env
    lazyeval::as.lazy(expr, env = env)
  }, dots)
  dots <- lazyeval::all_dots(dots)
  input <- partial_eval(dots, .data)
  update(.data, where = c(.data$where, input))
}
