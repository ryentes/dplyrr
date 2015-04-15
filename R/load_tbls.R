#' Load the table objects for all tables in a database
#'
#' @param db a database object
#' @param envir the environment to load table objects
#' 
#' @export
load_tbls <- function(db, envir = parent.frame(), verbose = TRUE) {
  if(missing(db)) {
    db <- eval(quote(db), envir = envir)
  }
  tbl_names <- dplyr::src_tbls(db)
  tbl_obj_names <- sprintf('%s_tbl', tbl_names)
  for(i in seq_along(tbl_obj_names)) {
    tbl_name <- tbl_names[i]
    tbl_obj_name <- tbl_obj_names[i]
    load_tbl <- function() {
      assign(tbl_obj_name, dplyr::tbl(db, tbl_name), envir = envir)
      if(verbose) cat(paste(sprintf("Loading: %s\n", tbl_obj_name)))
    }
    if(tbl_obj_name %in% ls(envir = envir)) {
      expr <- sprintf("!dplyr::db_has_table(%s$src$con, '%s')", tbl_obj_name, tbl_name)
      old_options <- options(show.error.messages = FALSE)
      is_closed_connection <- suppressWarnings(eval(parse(text=expr), envir=envir))
      options(old_options)
      if(is_closed_connection) {
        load_tbl()
      }
    } else {
      load_tbl()
    }
  }
  invisible()
}
