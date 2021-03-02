library(testthat)
test_that("filename", {
  expect_that(make_filename(1998), is_identical_to("accident_1998.csv.bz2"))
  expect_that(make_filename('1998'), is_identical_to("accident_1998.csv.bz2"))
})
