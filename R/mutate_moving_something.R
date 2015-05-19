#' translater for moving_**() added to mutate()
#' 
#' @param d a lazy before the translation
#' @return a lazy after the translation
#'
mutate_moving_something <- function(type=c("mean", "max", "min", "sum"), d) {
  type <- match.arg(type)
  args <- as.character(d$expr)
  if(length(args) <= 2) stop(sprintf("moving_%s() must have 2 argments at least.", type))
  expr <- sprintf("%s(%s)", type, args[2])
  lazyeval::as.lazy(expr, env = d$env)
}

#' extract moving_** arguments
#'
#' @param d a lazy
#' @return a lazy with arguments
#'
extract_moving_info <- function(d) {
  args <- as.character(d$expr)
  if(length(args) == 3) {
    move_num <- args[3]
    expr <- sprintf("move_info(%s, %s)", move_num, move_num)
  } else if(length(args) >= 4) {
    preceding <- args[3]
    following <- args[4]
    expr <- sprintf("move_info(%s, %s)", preceding, following)
  }
  lazyeval::as.lazy(expr, env = d$env)  
}
