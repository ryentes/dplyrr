#' dplyr mutate() added original functions for databases
#'
mutate_.tbl_sql <- function(.data, ..., .dots) {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)
  ### begin added area ###
  original_functions <- c("cut")
  dots <- Map(function(d) {
    function_name <- as.character(d$expr)[1]
    is_original <- function_name %in% original_functions
    if(is_original) {
      switch(function_name, 
             cut=mutate_cut(d),
             default=stop(sprintf("%s is not found in the original functions", function_name))
      )
    } else {
      d
    }
  }, dots)
  dots <- lazyeval::all_dots(dots)
  ### end added area ###
  input <- partial_eval(dots, .data)
  
  .data$mutate <- TRUE
  new <- update(.data, select = c(.data$select, input))
  # If we're creating a variable that uses a window function, it's
  # safest to turn that into a subquery so that filter etc can use
  # the new variable name
  if (dplyr:::uses_window_fun(input, .data)) {
    collapse(new)
  } else {
    new
  }
}
