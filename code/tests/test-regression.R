# Tests for residual_sum_squares()
context("Mean Squared Error (MSE)")

test_that("MSE is positive", {
    expect_true(mse(x,y) > 0)
    expect_false(mse(x,y) < 0)
})

test_that("y is the same length as x", {
    expect_equal(length(y), nrow(x))
})
