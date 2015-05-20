#' translater for count_if() or n_if() added to mutate()
#' 
#' @param d a lazy before the translation
#' 
#' @return a lazy after the translation
#'
mutate_count_if <- function(d) {
  args <- as.character(d$expr)
  if(length(args) < 2) 
    stop("n_if() and count_if() must have argument that is condition.")  
  condition <- args[2]
  expr <- sprintf("sum(if(%s) 1L else 0L)", condition)
  lazyeval::as.lazy(expr, env = d$env)
}
