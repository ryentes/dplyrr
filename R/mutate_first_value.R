#' translater for first_value() added to mutate()
#' 
#' @param d a lazy before the translation
#' @return a lazy after the translation
#'
mutate_first_value <- function(d) {
  args <- as.character(d$expr)
  if(length(args) <= 1) stop(sprintf("first_value() must have 1 argments at least."))
  random_str <- paste(sample(LETTERS, 10), collapse="")
  expr <- sprintf("rank(%s)", random_str)
  lazyeval::as.lazy(expr, env = d$env)
}

#' extract first_value() arguments
#'
#' @param d a lazy
#' @return a lazy with arguments
#'
extract_first_value_info <- function(dot, d) {
  random_str <- as.character(dot$expr)[2]
  args <- as.character(d$expr)
  if(length(args) == 2) {
    value <- args[2]
    order_by <- args[2]
  } else if(length(args) >= 3) {
    value <- args[2]
    order_by <- args[3]
  }
  expr <- sprintf("first_value(%s, %s, %s)", random_str, value, order_by)
  lazyeval::as.lazy(expr, env = d$env)  
}
