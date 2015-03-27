#' Compute moving average for PostgreSQL
#'
#' @param .data A tbl_postgres.
#' @param ... Name-value pairs of expressions.
#' 
#' @return An object of the same class as .data.
#'
#' @export
moving_average <- function(.data, ...) {
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
    name <- names[i]
    var_name <- input[[i]][1]
    n <- input[[i]][2] %>% as.integer
    if(name == "") name <- sprintf("moving_average_%s_%s", var_name, n)
    dots <- sprintf('mean(%s)', var_name)
    q <- q %>% collapse %>% mutate_(.dots = setNames(dots, name))
    q$query$sql <- q$query$sql %>% stringr::str_replace_all(UNBOUNDED, n)
  }
  if(stringr::str_detect(q$query$sql, DummyStr))
    q$query$sql <- q$query$sql %>% stringr::str_replace_all(DummyStr, UNBOUNDED)
  q
}
