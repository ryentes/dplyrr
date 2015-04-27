#' translater for cut() added to mutate()
#' 
#' @param d a lazy before the translation
#' 
#' @return a lazy after the translation
#'
mutate_cut <- function(d) {
  args <- as.list(match.call(base::cut.default, as.call(d$expr)))
  if(is.null(args$breaks)) stop("cut() needs breaks argument")
  if(is.null(args$include.lowest)) args$include.lowest = FALSE
  if(is.null(args$right)) args$right = TRUE
  if(is.null(args$dig.lab)) args$dig.lab = 3
  if(args$right) {
    lower.op <- ">"
    higher.op <- "<="
  } else {
    lower.op <- ">="
    higher.op <- "<"
  }
  args$x <- deparse(args$x)
  args$breaks <- eval(args$breaks, env = d$env)
  args$include.lowest <- eval(args$include.lowest, env = d$env)
  args$right <- eval(args$right, env = d$env)
  args$dig.lab <- eval(args$dig.lab, env = d$env)
  if(is.null(args$labels)) {
    args$labels <- with(args, {
      levels(cut(0, breaks = breaks, include.lowest = include.lowest, 
                 right = right, dig.lab = dig.lab))
    })
  } else {
    args$labels <- eval(args$labels, env = d$env)
  }
  expr <- with(args, {
    expr <- ""
    n <- length(args$labels)
    for(i in seq_along(labels)) {
      if(i == 1 && breaks[1] == -Inf) {
        expr <- sprintf('if(%s %s %s) "%s" else', x, higher.op, breaks[2], labels[1])
      } else if(i == 1 && include.lowest && right) {
        expr <- sprintf('if(%s >= %s & %s %s %s) "%s" else', x, breaks[1], x, higher.op, breaks[2], labels[1])
      } else if(i == n && breaks[n+1] == Inf) {
        expr <- sprintf('%s if(%s %s %s) "%s" else', expr, x, lower.op, breaks[n], labels[n])
      } else if(i == n && include.lowest && !right) {
        expr <- sprintf('%s if(%s %s %s & %s <= %s) "%s" else', expr, x, lower.op, breaks[n], x, breaks[n+1], labels[n])
      } else {
        expr <- sprintf('%s if(%s %s %s & %s %s %s) "%s" else', expr, x, lower.op, breaks[i], x, higher.op, breaks[i+1], labels[i])
      }
    }
    sprintf("%s NA", expr)
  })
  lazyeval::as.lazy(expr, env = d$env)
}
