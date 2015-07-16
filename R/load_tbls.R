#' Load the table objects for all tables in a database
#'
#' @param db a database object
#' @param prefix a prefix string for names of table objects. default is empty.
#' @param suffix a suffix string for names of table objects. default is "_tbl".
#' @param envir the environment to load table objects
#' @param verbose logical. indicates whether to display status. default is TRUE.
#' @param tolower logical. indicates whether to convert the names of table objects to lower case. default is TRUE.
#' @param force logical. indicates whether to load tables forced. deafult is FALSE.
#' 
#' @export
load_tbls <- function(db, 
                      prefix = "", 
                      suffix = "_tbl", 
                      envir = parent.frame(), 
                      verbose = TRUE, 
                      tolower = TRUE,
                      force = FALSE) {
  if(missing(db)) {
    db <- eval(quote(db), envir = envir)
  }
  tbl_names <- dplyr::src_tbls(db)
  if(tolower) {
    tbl_obj_names <- paste0(prefix, tolower(tbl_names), suffix)
  } else {
    tbl_obj_names <- paste0(prefix, tbl_names, suffix)
  }
  for(i in seq_along(tbl_obj_names)) {
    tbl_name <- tbl_names[i]
    tbl_obj_name <- tbl_obj_names[i]
    load_tbl <- function() {
      if(DBI::dbExistsTable(db$con, tbl_name)) {
        assign(tbl_obj_name, dplyr::tbl(db, tbl_name), envir = envir)
        if(verbose) message(paste(sprintf("Loading: %s", tbl_obj_name)))
      }
    }
    if(force || !(tbl_obj_name %in% ls(envir = envir))) {
      load_tbl()
    } else {
      expr <- sprintf("!dplyr::db_has_table(%s$src$con, '%s')", tbl_obj_name, tbl_name)
      options(show.error.messages = FALSE)
      tryCatch({
        is_closed_connection <- suppressWarnings(eval(parse(text=expr), envir=envir))
        if(is_closed_connection) {
          load_tbl()
        }
      }, error=function(e) {
        stop(e)
      }, finally={
        options(show.error.messages = TRUE)
      })
    }
  }
  invisible()
}
