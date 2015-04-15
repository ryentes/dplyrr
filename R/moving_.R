#' Compute moving ** for PostgreSQL
#'
#' @param type A string.
#' @param .data A tbl_postgres.
#' @param ... Name-value pairs of expressions.
#' 
#' @return An object of the same class as .data.
#'
#' @export
moving_ <- function(type=c("mean", "max", "min", "sum"), .data, ...) {
  type <- match.arg(type)
  UNBOUNDED <- "UNBOUNDED"
  DummyStr <- "#3#1#4#1#5#"
  if(stringr::str_detect(.data$query$sql, UNBOUNDED))
    .data$query$sql <- .data$query$sql %>% stringr::str_replace_all(UNBOUNDED, DummyStr)
  
  dots <- lazyeval::lazy_dots(...)
  input <- dplyr::partial_eval(dots, .data)
  input <- input %>% Map(as.character, .)
  names <- names(input)

  q <- .data
  for(i in seq_along(names)) {
    if(length(input[[i]]) <= 1) {
      stop("cannot recognize input for moving_*()")
    }
    name <- names[i]
    var_name <- input[[i]][1]
    n <- input[[i]][2] %>% as.integer
    if(name == "") name <- sprintf("moving_%s_%s_%s", type, var_name, n)
    dots <- sprintf("%s(%s)", type, var_name)
    q <- q %>% collapse %>% mutate_(.dots = setNames(dots, name))
    q$query$sql <- q$query$sql %>% stringr::str_replace_all(UNBOUNDED, n)
  }
  if(stringr::str_detect(q$query$sql, DummyStr))
    q$query$sql <- q$query$sql %>% stringr::str_replace_all(DummyStr, UNBOUNDED)
  q
}
