#' Simulate Activity Sensor Data
#'
#' Generates synthetic daily activity sensor readings for each cow,
#' including activity score, steps, and lying/standing time.
#'
#' @param herd A tibble produced by [simulate_herd()].
#' @param seed Integer. Random seed for reproducibility. Default is NULL.
#'
#' @return The input tibble with additional columns: `activity_score`,
#'   `steps`, `lying_minutes`, `standing_minutes`.
#'
#' @details
#' - Lying and standing minutes always sum to 1440 (24 hours)
#' - Activity is higher in early lactation and declines with DIM
#' - Steps are positively correlated with activity score
#'
#' @examples
#' herd <- simulate_herd(100, seed = 1)
#' activity <- simulate_activity(herd, seed = 1)
#'
#' @export
simulate_activity <- function(herd, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  n   <- nrow(herd)
  dim <- herd$days_in_milk

  base_activity  <- 80 - 0.05 * dim
  activity_score <- round(pmax(stats::rnorm(n, mean = base_activity, sd = 10), 10))
  steps          <- round(pmax(stats::rnorm(n, mean = activity_score * 35, sd = 400), 100))

  lying_minutes <- round(pmin(pmax(
    stats::rnorm(n, mean = 720 - activity_score * 1.5, sd = 60),
    300), 900))

  dplyr::mutate(herd,
    activity_score   = activity_score,
    steps            = steps,
    lying_minutes    = lying_minutes,
    standing_minutes = 1440L - lying_minutes
  )
}
