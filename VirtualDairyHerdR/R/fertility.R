#' Simulate Fertility Records
#'
#' Generates cow-level fertility outcomes. Conception probability is
#' influenced by lactation number, days in milk, and milk yield (high
#' producers are harder to get in calf — the production-fertility antagonism).
#'
#' @param milk A tibble produced by [simulate_milk()] or [simulate_mastitis()].
#' @param seed Integer. Random seed for reproducibility. Default is NULL.
#'
#' @return The input tibble with additional columns: `days_to_first_service`,
#'   `conception_attempt`, `pregnant`, `days_open`.
#'
#' @details
#' Conception probability is modelled as a logistic function of:
#' - Lactation number (parity penalty for older cows)
#' - Days in milk at first service (optimal window ~50–80 DIM)
#' - Milk yield (negative effect — dilution of energy balance)
#'
#' - `days_to_first_service` — voluntary waiting period + noise (~42–70 days)
#' - `conception_attempt` — number of services to conception (1–4), or NA if open
#' - `pregnant` — logical; TRUE if cow conceived
#' - `days_open` — days from calving to conception; NA if not pregnant
#'
#' @examples
#' herd <- simulate_herd(100, seed = 1)
#' milk <- simulate_milk(herd, seed = 1)
#' fert <- simulate_fertility(milk, seed = 1)
#'
#' @export
simulate_fertility <- function(milk, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  n   <- nrow(milk)
  dim <- milk$days_in_milk

  days_to_first_service <- round(pmax(stats::rnorm(n, mean = 56, sd = 8), 42))

  # Logistic conception probability
  lact_penalty  <- -0.15 * (milk$lactation - 1)
  dim_penalty   <- -0.005 * abs(dim - 65)          # optimal ~65 DIM
  yield_penalty <- -0.02  * (milk$milk_kg - 25)    # penalty above 25 kg

  log_odds <- 0.8 + lact_penalty + dim_penalty + yield_penalty
  p_conception <- 1 / (1 + exp(-log_odds))
  p_conception <- pmin(pmax(p_conception, 0.25), 0.75)

  pregnant          <- stats::runif(n) < p_conception
  conception_attempt <- rep(NA_integer_, n)
  days_open          <- rep(NA_real_,    n)

  if (any(pregnant)) {
    idx <- which(pregnant)
    conception_attempt[idx] <- sample(1:4, length(idx), replace = TRUE,
                                      prob = c(0.55, 0.25, 0.12, 0.08))
    days_open[idx] <- round(
      days_to_first_service[idx] + (conception_attempt[idx] - 1) * 21 +
        stats::rnorm(length(idx), 0, 3)
    )
  }

  dplyr::mutate(milk,
    days_to_first_service = days_to_first_service,
    conception_attempt    = conception_attempt,
    pregnant              = pregnant,
    days_open             = days_open
  )
}
