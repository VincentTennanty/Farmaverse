#' Simulate a Dairy Herd
#'
#' Generates a synthetic dairy herd with cow-level attributes. Can be driven
#' by a farm configuration object from [simulate_farm()]. Optionally expands
#' the herd into a longitudinal dataset with one row per cow per day of
#' lactation (DIM 1–305).
#'
#' @param n_cows Integer. Number of cows to generate. Overrides `farm$n_cows`
#'   if both are supplied. Default is 100.
#' @param farm A farm configuration list from [simulate_farm()]. Optional.
#' @param longitudinal Logical. If `TRUE`, expands each cow to one row per DIM
#'   (1–305), producing a time series tibble. Default is `FALSE`.
#' @param seed Integer. Random seed for reproducibility. Default is NULL.
#'
#' @return A tibble with columns: `cow_id`, `breed`, `age`, `lactation`,
#'   `days_in_milk`, `synthetic_data`, `source`. When `longitudinal = TRUE`,
#'   each cow has 305 rows (one per DIM) and `days_in_milk` runs 1–305.
#'
#' @examples
#' # Snapshot herd
#' herd <- simulate_herd(100, seed = 42)
#'
#' # Longitudinal herd — one row per cow per DIM
#' herd_long <- simulate_herd(20, longitudinal = TRUE, seed = 42)
#'
#' farm <- simulate_farm(n_cows = 200, seed = 42)
#' herd <- simulate_herd(farm = farm)
#'
#' @export
simulate_herd <- function(n_cows = 100, farm = NULL, longitudinal = FALSE,
                          seed = NULL) {
  if (!is.null(farm)) {
    if (is.null(seed)) seed <- farm$seed
    n_cows <- farm$n_cows
  }
  if (!is.null(seed)) set.seed(seed)

  breeds        <- c("Holstein", "Friesian", "Jersey", "Crossbred")
  breed_weights <- c(0.45, 0.30, 0.15, 0.10)

  lactation <- sample(1:6, n_cows, replace = TRUE,
                      prob = c(0.25, 0.22, 0.20, 0.15, 0.10, 0.08))

  herd <- tibble::tibble(
    cow_id         = sprintf("COW%04d", seq_len(n_cows)),
    breed          = sample(breeds, n_cows, replace = TRUE, prob = breed_weights),
    age            = lactation + 1L + sample(0:1, n_cows, replace = TRUE),
    lactation      = lactation,
    days_in_milk   = sample(1:305, n_cows, replace = TRUE),
    synthetic_data = TRUE,
    source         = "VirtualDairyHerdR"
  )

  if (!longitudinal) return(herd)

  # Expand each cow to one row per DIM 1:305
  herd$days_in_milk <- NULL
  herd[rep(seq_len(n_cows), each = 305), ] |>
    dplyr::mutate(days_in_milk = rep(1:305, times = n_cows))
}
