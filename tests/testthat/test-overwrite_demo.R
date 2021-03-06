test_that("has the expected names", {
  expect_named(
    overwrite_demo,
    c("level", "id_2dii", "name", "sector", "source")
  )
})

test_that("hasn't changed", {
  expect_known_value(
    overwrite_demo, "ref-overwrite_demo",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-overwrite_demo"))
  expect_identical(overwrite_demo, reference)
})
