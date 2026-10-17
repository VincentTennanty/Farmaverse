#' Simulate Milk Production
#'
#' Generates daily milk yield, fat, protein, and somatic cell count for each
#' cow. Builds on the lactation curve from [simulate_lactation()], adding
#' daily residual noise and milk composition.
#'
#' @param herd A tibble produced by [simulate_herd()].
#' @param seed Integer. Random seed for reproducibility. Default is NULL.
#'
#' @return The input tibble with additional columns: `milk_kg`, `fat_percent`,
#'   `protein_percent`, `scc`.
#'
#' @details
#' - Milk yield uses Wood's curve via [simulate_lactation()] plus daily noise
#' - Fat and protein are negatively correlated with yield (dilution effect)
#' - SCC is log-normally distributed and increases slightly with DIM
#'
#' @examples
#' herd <- simulate_herd(100, seed = 1)
#' milk <- simulate_milk(herd, seed = 1)
#'
#' @export
simulate_milk <- function(herd, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  lact <- simulate_lactation(herd, seed = seed)
  n    <- nrow(lact)
  dim  <- lact$days_in_milk

  milk_kg <- pmax(lact$predicted_yield + stats::rnorm(n, 0, 1.2), 0.5)

  fat_pct     <- stats::rnorm(n, mean = 4.2 - 0.02 * milk_kg, sd = 0.3)
  protein_pct <- stats::rnorm(n, mean = 3.4 - 0.01 * milk_kg, sd = 0.2)
  log_scc     <- stats::rnorm(n, mean = 4.5 + 0.002 * dim,    sd = 0.5)

  dplyr::mutate(herd,
    milk_kg         = round(milk_kg, 2),
    fat_percent     = round(pmax(fat_pct, 2.0), 2),
    protein_percent = round(pmax(protein_pct, 2.0), 2),
    scc             = round(exp(log_scc))
  )
}
