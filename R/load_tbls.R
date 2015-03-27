#' Load the table objects for all tables in a database
#'
#' @param db a database object
#' @param envir the environment to load table objects
#' 
#' @export
load_tbls <- function(db, envir = parent.frame()) {
  tbl_names <- dplyr::src_tbls(db)
  commands <- sprintf('%s_tbl <- tbl(db, "%s")', tbl_names, tbl_names)
  eval(parse(text = commands), envir = envir)
}
