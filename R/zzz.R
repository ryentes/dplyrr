.onAttach <- function(libname, pkgname) {
  dplyr_env <- asNamespace("dplyr")
  # overwriting filter()
  unlockBinding("filter_.tbl_sql", env = dplyr_env)
  assign("filter_.tbl_sql", filter_.tbl_sql, envir = dplyr_env)
  lockBinding("filter_.tbl_sql", env = dplyr_env)
  # overwriting mutate()
  unlockBinding("mutate_.tbl_sql", env = dplyr_env)
  assign("mutate_.tbl_sql", mutate_.tbl_sql, envir = dplyr_env)
  lockBinding("mutate_.tbl_sql", env = dplyr_env)
}
