#' Update the package
#'
#' @usage update_dplyrr()
#' @export
update_dplyrr <- function() {
  devtools::install_github("hoxo-m/dplyrr")
}

#' Unload the package
#'
#' @usage unload_dplyrr()
#' @export
unload_dplyrr <- function() {
  detach("package:dplyrr", unload = TRUE)
  detach("package:dplyr", unload = TRUE)
}
