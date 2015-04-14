.onAttach <- function(libname, pkgname) {
  dplyr_env <- asNamespace("dplyr")
  unlockBinding("filter_.tbl_sql", env = dplyr_env)
  assign("filter_.tbl_sql", filter_.tbl_sql, envir = dplyr_env)
  lockBinding("filter_.tbl_sql", env = dplyr_env)
}
