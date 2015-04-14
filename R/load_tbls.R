#' Load the table objects for all tables in a database
#'
#' @param db a database object
#' @param envir the environment to load table objects
#' 
#' @export
load_tbls <- function(db, envir = parent.frame(), verbose = TRUE) {
  tbl_names <- dplyr::src_tbls(db)
  tbl_obj_names <- sprintf('%s_tbl', tbl_names)
  for(i in seq_along(tbl_obj_names)) {
    tbl_name <- tbl_names[i]
    tbl_obj_name <- tbl_obj_names[i]
    assign(tbl_obj_name, dplyr::tbl(db, tbl_name), envir = envir)
    if(verbose) cat(paste(sprintf("Loading: %s\n", tbl_obj_name)))
  }
  invisible()
}
