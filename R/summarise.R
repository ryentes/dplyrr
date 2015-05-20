summarise_.tbl_sql <- function (.data, ..., .dots) {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)

  ### begin added area ###
  original_functions <- c("n_if", "count_if")
  dots <- Map(function(d) {
    function_name <- as.character(d$expr)[1]
    is_original <- function_name %in% original_functions
    if(is_original) {
      switch(function_name, 
             count_if=mutate_count_if(d),
             n_if=mutate_count_if(d),
             default=stop(sprintf("%s is not found in the original functions", function_name))
      )
    } else {
      d
    }
  }, dots)
  dots <- lazyeval::all_dots(dots)
  ### end added area ###
  
  input <- partial_eval(dots, .data)
  if (.data$mutate) {
    .data <- collapse(.data)
  }
  .data$summarise <- TRUE
  .data <- update(.data, select = c(.data$group_by, input))
  update(collapse(.data), group_by = dplyr:::drop_last(.data$group_by))
}
