# fars_read ----
#' Read .csv.bz2 into data.frame
#'
#' This is a function that reads the .csv file in a compressed file into a
#'    data.frame in R.
#'
#' @param filename A character string giving the name of the compressed
#'    file.
#'
#' @return This function returns a data.frame containing the data
#'    in the .csv file.
#'
#' @details The directory of the file should be the same as the working
#'    directory. Otherwise the function will stop with an error.
#'
#' @examples
#' \dontrun{
#'  fars_read("accident_2013.csv")
#' }
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}


# make_filename ----
#' Standardized Filename Based on a Specific Year
#'
#' This is function that makes a standardized filename based on a
#'    specific year. For example, with input 2021, the output will
#'    be a character string "accident_2021.csv.bz2".
#'
#' @param year An integer specifying a year.
#'
#' @return This function returns a character string with the format
#'    "accident_%(year).csv.bz2".
#'
#' @examples
#' make_filename(1990)
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}


# fars_read_years ----
#' Fetch 'Year' and 'Month' of the Records
#'
#' This is a function that fetches the 'year' and 'MONTH' columns of the
#'    records of regarding fatal injuries, in the specific given years.
#'
#' @param years A numeric vector that specifying the years of interest.
#'
#' @return A list. Each element is a data.frame containing the corresponding
#'    'year' and 'MONTH' columns.
#'
#' @details If a file for a year does not exist in the working directory,
#'    the return value will be NULL with a warning message.
#'
#' @examples
#' \dontrun{
#'  fars_read_years(c(2013,2014,2015))
#'  fars_read_years(c(2013,2016))
#' }
#'
#' @import magrittr
#'
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}


# fars_summarize_year ----
#' Summarize the counts of fatal injuries
#'
#' This is a function that Summarize the counts of fatal injuries
#'    for each month, given specific years.
#'
#' @param years A numeric vector that specifying the years of interest.
#'
#' @return A data.frame with 12 rows and \code{length(years)} columns.
#'     Each row represents a month, and each column represents a year.
#'
#' @details If a file for a year does not exist in the working directory,
#'    the returned data.frame will not contain the corresponding column,
#'    with a warning message.
#'
#' @examples
#' \dontrun{
#'  fars_summarize_years(c(2013,2014))
#'  fars_summarize_years(c(2013,2015))
#' }
#'
#' @import magrittr
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}


# fars_map_state ----
#' The Map of Records in a State
#'
#' This is a function that draws the map of the given state, and the
#'    records are shown on the map as dots according to their locations.
#'
#' @param state.num A character string or a integer giving the state number.
#' @param year An integer specifying a year.
#'
#' @return A map featuring the boundary of the state based on the records,
#'    the state, and also the recoreds as dots inside the state.
#'
#' @details 1. the function will stop with an error. 2. If the input state.num does not match any
#'    record, the function will stop with the error "invalid STATE number". 3. If no records match
#'    the given year and state, the function will stop with the message "no accidents to plot".
#'
#' @examples
#' \dontrun{
#'  fars_map_state(5, 2014)
#'  fars_map_state(3, 2013)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
