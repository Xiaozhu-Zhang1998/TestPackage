# TestPackage
[![Build Status](https://travis-ci.org/Xiaozhu-Zhang1998/TestPackage.svg?branch=master)](https://travis-ci.org/Xiaozhu-Zhang1998/TestPackage)
This is a small test package for R, including 5 functions. 

## Installation
Two methods are recommended here.

### The first method
The first method is to use `devtools::install_github()`:
  library(devtools)
  install_github("Xiaozhu-Zhang1998/TestPackage", build_vignettes = TRUE)
The package will then be stored in the default directory `.libPaths()`. 

### The second method
In cases where users might have a weak internet connection, it’s often easier to download the source of the package as a zip file (from the GitHub Repo), and then to install it using `install.packages()`:
  install.packages(file.choose(), repos = NULL, type = "source")  
Users can interactively select the file they just downloaded.


## Functions
`fars_read`: This is a function that reads the .csv file in a compressed file into a data.frame in R.

`make_filename`: This is function that makes a standardized filename based on a specific year. For example, with input 2021, the output will be a character string "accident_2021.csv.bz2".

`fars_read_years`: This is a function that fetches the 'year' and 'MONTH' columns of the records of regarding fatal injuries, in the specific given years.

`fars_summarize_year`: This is a function that Summarize the counts of fatal injuries for each month, given specific years.

`fars_map_state`: This is a function that draws the map of the given state, and the records are shown on the map as dots according to their locations.

For more details, please visit the help files by typing `?function` in the console.

## Author(s)
- Xiaozhu Zhang
