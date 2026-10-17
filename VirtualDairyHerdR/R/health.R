#' Simulate Mastitis Events
#'
#' Applies mastitis disease effects to a milk dataset, generating a labelled
#' dataset suitable for machine learning classification exercises.
#'
#' @param milk A tibble produced by [simulate_milk()].
#' @param prevalence Numeric. Proportion of cows with mastitis (0–1).
#'   Default is 0.15.
#' @param seed Integer. Random seed for reproducibility. Default is NULL.
#'
#' @return The input tibble with additional columns: `temperature`,
#'   `rumination_minutes`, `mastitis` (logical).
#'
#' @details
#' Mastitis effects applied to cases:
#' - Milk yield reduced by 15–40%
#' - SCC elevated 5–20x
#' - Body temperature increased +0.5 to +2.5 °C
#' - Rumination reduced by 20–50%
#'
#' @examples
#' herd <- simulate_herd(100, seed = 1)
#' milk <- simulate_milk(herd, seed = 1)
#' health <- simulate_mastitis(milk, prevalence = 0.15, seed = 1)
#'
#' @export
simulate_mastitis <- function(milk, prevalence = 0.15, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  n <- nrow(milk)

  temperature        <- round(stats::rnorm(n, mean = 38.5, sd = 0.3), 1)
  rumination_minutes <- round(pmax(stats::rnorm(n, mean = 480, sd = 45), 200))

  mastitis <- sample(c(TRUE, FALSE), n, replace = TRUE,
                     prob = c(prevalence, 1 - prevalence))

  if (any(mastitis)) {
    idx <- which(mastitis)

    milk$milk_kg[idx] <- round(
      milk$milk_kg[idx] * stats::runif(length(idx), 0.60, 0.85), 2)

    milk$scc[idx] <- milk$scc[idx] *
      round(stats::runif(length(idx), 5, 20))

    temperature[idx] <- round(
      temperature[idx] + stats::runif(length(idx), 0.5, 2.5), 1)

    rumination_minutes[idx] <- round(
      rumination_minutes[idx] * stats::runif(length(idx), 0.50, 0.80))
  }

  dplyr::mutate(milk,
    temperature        = temperature,
    rumination_minutes = rumination_minutes,
    mastitis           = mastitis
  )
}
