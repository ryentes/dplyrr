#' dplyr mutate() added original functions for databases
#'
mutate_.tbl_sql <- function(.data, ..., .dots) {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)
  ### begin added area ###
  original_functions <- c("cut", "moving_mean", "moving_max", "moving_min", "moving_sum")
  infos <- Map(function(d) {
    function_name <- as.character(d$expr)[1]
    is_original <- function_name %in% original_functions
    moving_info <- NULL
    if(is_original) {
      dot <- switch(function_name, 
                  cut=mutate_cut(d),
                  moving_mean=mutate_moving_something("mean", d),
                  moving_max=mutate_moving_something("max", d),
                  moving_min=mutate_moving_something("min", d),
                  moving_sum=mutate_moving_something("sum", d),
                  default=stop(sprintf("%s is not found in the original functions", function_name))
      )
      if(function_name %in% c("moving_mean", "moving_max", "moving_min", "moving_sum")) {
        moving_info <- extract_moving_info(d)
      }
      d <- dot
    }
    list(d=d, moving_info=moving_info)
  }, dots)
  dots <- Map(function(info) info$d, infos)
  dots <- lazyeval::all_dots(dots)
  moving_infos <- Map(function(info) info$moving_info, infos)
  moving_infos <- Filter(function(info) !is.null(info), moving_infos)
  moving_infos <- lazyeval::all_dots(moving_infos)
  moving_infos <- partial_eval(moving_infos, .data)
  ### end added area ###
  input <- partial_eval(dots, .data)
  
  .data$mutate <- TRUE
  new <- update(.data, select = c(.data$select, input))
  ### begin added area ###
  if(length(moving_infos) > 0) {
    UNBOUNDED <- "UNBOUNDED"
    count_UNBOUNDED_pre <- stringr::str_count(.data$query$sql, UNBOUNDED)
    count_UNBOUNDED_post <- stringr::str_count(new$query$sql, UNBOUNDED)
    if(count_UNBOUNDED_pre + 2 * length(moving_infos) != count_UNBOUNDED_post)
      stop("Cannot contain moving_**() with other window functions in one mutate(). Please separate it such as mutate(A) %>% mutate(B)")
    for(info in moving_infos) {
      args <- as.character(info)
      preceding <- args[2]
      following <- args[3]
      new$query$sql <- stringr::str_replace(new$query$sql, UNBOUNDED, preceding)
      new$query$sql <- stringr::str_replace(new$query$sql, UNBOUNDED, following)
    }
  }
  ### end added area ###
  # If we're creating a variable that uses a window function, it's
  # safest to turn that into a subquery so that filter etc can use
  # the new variable name
  if (dplyr:::uses_window_fun(input, .data)) {
    collapse(new)
  } else {
    new
  }
}
