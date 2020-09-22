library(dplyr)
library(data.table)
library(dtplyr)
library(collapse)
library(nycflights13)
library(microbenchmark)

# dplyr
microbenchmark({flights %>%
    group_by(carrier) %>%
    summarize(arr_delay = mean(arr_delay, na.rm = TRUE), .groups = "drop")
})

# data.table
microbenchmark({
  data.table(flights)[,.(arr_delay = mean(arr_delay, na.rm = TRUE)), by = .(carrier)]
})


# dtplyr
microbenchmark({
  flights %>%
    lazy_dt() %>%
    group_by(carrier) %>%
    summarize(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
    as_tibble()
})


# collapse
microbenchmark({
  suppressMessages(flights %>%
    group_by(carrier) %>%
    select(arr_delay) %>%
    fmean()) # message on adding missing grouping vars
})
