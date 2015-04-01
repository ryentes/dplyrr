#' Create a case statement by using like the base::cut().
#'
#' @param .data A tbl.
#' @param ... a name-value pair of expression.
#' @param breaks a numeric vector of two or more unique cut points.
#' @param labels labels for the levels of the resulting category. By default, labels are constructed using "(a,b]" interval notation.
#' @param include.lowest logical, indicating if the lowest category contains the lowest value.
#' @param right logical, indicating if the intervals should be closed on the right (and open the left) or vice versa.
#' @param dig.lab integer which is used when labels are not given. It determines the number of digits used in formatting the break numbers.
#'
#' @export 
case_cut <- function(.data, ..., breaks, labels = NULL, include.lowest = FALSE, right = TRUE, dig.lab = 3) {
  dots <- lazyeval::lazy_dots(...)
  input <- dplyr::partial_eval(dots, .data)
  input <- Map(as.character, input)
  name <- names(input)
  if(name == "") name = sprintf("case_cut(%s)", input)
  if(right) {lower.op <- ">"; higher.op <- "<="} else {lower.op <- ">="; higher.op <- "<"}
  dots <- ""
  
  if(is.null(labels)) {
    labels <- levels(cut(0, breaks, labels, include.lowest, right, dig.lab))
  }
  for(i in seq_along(labels)) {
    n <- length(labels)
    if(i == 1 && breaks[1] == -Inf) {
      dots <- sprintf('%s if(%s %s %s) "%s" else', dots, input, higher.op, breaks[2], labels[1])
    } else if(i == 1 && include.lowest) {
      dots <- sprintf('%s if(%s >= %s & %s %s %s) "%s" else', dots, input, breaks[i], input, higher.op, breaks[i+1], labels[i])
    } else if(i == n && breaks[n+1] == Inf) {
      dots <- sprintf('%s if(%s %s %s) "%s" else', dots, input, lower.op, breaks[n], labels[n])
    } else {
      dots <- sprintf('%s if(%s %s %s & %s %s %s) "%s" else', dots, input, lower.op, breaks[i], input, higher.op, breaks[i+1], labels[i])
    }
  }
  dots <- sprintf("%s NA", dots)
  
  q <- .data %>% collapse %>% mutate_(.dots = setNames(dots, name))
  q
}
