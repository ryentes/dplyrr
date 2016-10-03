.onAttach <- function(libname, pkgname) {
  dplyr_env <- asNamespace("dplyr")
  # overwriting mutate()
  unlockBinding("mutate_.tbl_sql", env = dplyr_env)
  assign("mutate_.tbl_sql", mutate_.tbl_sql, envir = dplyr_env)
  lockBinding("mutate_.tbl_sql", env = dplyr_env)
  # overwriting summarise()
  unlockBinding("summarise_.tbl_sql", env = dplyr_env)
  assign("summarise_.tbl_sql", summarise_.tbl_sql, envir = dplyr_env)
  lockBinding("summarise_.tbl_sql", env = dplyr_env)
}
