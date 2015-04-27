is_integer_or_infinaite <- function(values) {
  all(ifelse(is.finite(values), values %% 1 == 0, TRUE))
}

generate_range_labels <- function(breaks, include.lowest = FALSE, right = TRUE,
                                  center = "-", left_char = "", right_char = "") {
  if(is_integer_or_infinaite(breaks)) {
    len <- length(breaks) - 1
    labels <- character(len)
    for(i in seq_len(len)) {
      p <- breaks[i]
      n <- breaks[i+1]
      if(right) {
        if(i != 1 || !include.lowest) {
          p <- p + 1
        }
        if(p == -Inf) {
          label <- sprintf("%s%s%s%s", left_char, center, n, right_char)
        } else if(n == Inf) {
          label <- sprintf("%s%s%s%s", left_char, p, center, right_char)
        } else if(p == n) {
          label <- sprintf("%s%s%s", left_char, p, right_char)
        } else {
          label <- sprintf("%s%s%s%s%s", left_char, p, center, n, right_char)
        }
      } else {
        if(i != len || !include.lowest) {
          n <- n - 1
        }
        if(p == -Inf) {
          label <- sprintf("%s%s%s%s", left_char, center, n, right_char)
        } else if(n == Inf) {
          label <- sprintf("%s%s%s%s", left_char, p, center, right_char)
        } else if(p == n) {
          label <- sprintf("%s%s%s", left_char, p, right_char)
        } else {
          label <- sprintf("%s%s%s%s%s", left_char, p, center, n, right_char)
        }
      } 
      labels[i] <- label
    }
    labels
  } else {
    stop("breaks are not integer or infinite")
  }
}
