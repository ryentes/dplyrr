#' Load the table objects for all tables in a database
#'
#' @param db a database object
#' @param envir the environment to load table objects
#' 
#' @export
load_tbls <- function(db, envir = parent.frame(), verbose = TRUE) {
  tbl_names <- dplyr::src_tbls(db)
  tbl_obj_names <- sprintf('%s_tbl', tbl_names)
  commands <- sprintf('tbl(db, "%s")', tbl_names)
  for(i in seq_along(tbl_obj_names)) {
    tbl_obj_name <- tbl_obj_names[i]
    command <- commands[i]
    assign(tbl_obj_name, eval(command), envir = envir)
    if(verbose) cat(paste(sprintf("%s <- %s\n", tbl_obj_name, command)))
  }
  invisible(NULL)
}
