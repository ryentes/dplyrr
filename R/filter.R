#' Improved filter for tbl_sql which adds parentheses
#'
#' @param .data A tbl_sql.
#' @param ... Logical predicates. Multiple conditions are combined with &.
#' @param .dots Used to work around non-standard evaluation.
#' @return An object of tbl_sql.
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
