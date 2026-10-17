#' Simulate Lactation Curves
#'
#' Generates cow-level Wood's lactation curve parameters and predicted daily
#' milk yield for each cow's current days in milk. This is the biological
#' engine underlying [simulate_milk()].
#'
#' Wood's model: `Y = a * DIM^b * exp(-c * DIM)`
#'
#' @param herd A tibble produced by [simulate_herd()].
#' @param seed Integer. Random seed for reproducibility. Default is NULL.
#'
#' @return The input tibble with additional columns: `wood_a`, `wood_b`,
#'   `wood_c`, `peak_dim`, `peak_yield`, `predicted_yield`.
#'
#' @details
#' - `wood_a` — scale parameter (drives overall yield level)
#' - `wood_b` — inclining slope (time to peak)
#' - `wood_c` — declining slope (persistency)
#' - `peak_dim` — predicted day of peak yield = `b / c`
#' - `peak_yield` — predicted peak yield in kg
#'
#' Breed and lactation adjustments are applied to `wood_a`. Individual
#' cow-level random effects are added to all three parameters.
#'
#' @examples
#' herd <- simulate_herd(100, seed = 1)
#' lact <- simulate_lactation(herd, seed = 1)
#'
#' @export
simulate_lactation <- function(herd, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  n <- nrow(herd)

  breed_adj <- ifelse(herd$breed == "Jersey",    -5,
               ifelse(herd$breed == "Crossbred", -2, 0))
  lact_adj  <- ifelse(herd$lactation >= 4, -1.5, 0)

  wood_a <- pmax(18 + breed_adj + lact_adj + stats::rnorm(n, 0, 2.5), 5)
  wood_b <- pmax(0.25 + stats::rnorm(n, 0, 0.02), 0.10)
  wood_c <- pmax(0.0035 + stats::rnorm(n, 0, 0.0003), 0.001)

  peak_dim   <- round(wood_b / wood_c)
  peak_yield <- round(wood_a * (peak_dim ^ wood_b) * exp(-wood_c * peak_dim), 2)

  dim             <- herd$days_in_milk
  predicted_yield <- round(wood_a * (dim ^ wood_b) * exp(-wood_c * dim), 2)

  dplyr::mutate(herd,
    wood_a          = round(wood_a, 3),
    wood_b          = round(wood_b, 4),
    wood_c          = round(wood_c, 5),
    peak_dim        = peak_dim,
    peak_yield      = peak_yield,
    predicted_yield = pmax(predicted_yield, 0.5)
  )
}
