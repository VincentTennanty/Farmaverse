#' Summarise a Virtual Herd Dataset
#'
#' Produces a grouped summary table from any stage of the simulation pipeline.
#' Designed for teaching — students can aggregate by herd, breed, lactation
#' number, or any other grouping variable present in the data.
#'
#' @param data A tibble from any simulation step (e.g. [simulate_milk()],
#'   [simulate_mastitis()], [simulate_fertility()]).
#' @param by Character vector of column names to group by. Default is `NULL`
#'   (whole-herd summary). Common options: `"breed"`, `"lactation"`,
#'   `c("breed", "lactation")`.
#'
#' @return A tibble with one row per group containing summary statistics for
#'   whichever of the following columns are present in `data`:
#'   `milk_kg`, `fat_percent`, `protein_percent`, `scc`, `days_in_milk`,
#'   `pregnant`, `days_open`, `activity_score`, `mastitis`.
#'
#' @examples
#' herd <- simulate_herd(100, seed = 1)
#' milk <- simulate_milk(herd, seed = 1)
#'
#' # Whole-herd summary
#' education_summary(milk)
#'
#' # By breed
#' education_summary(milk, by = "breed")
#'
#' # By lactation number
#' education_summary(milk, by = "lactation")
#'
#' # By breed and lactation
#' education_summary(milk, by = c("breed", "lactation"))
#'
#' @export
education_summary <- function(data, by = NULL) {

  # Optional numeric summaries — only included if column exists
  summarise_if_present <- function(data, col, label_mean, label_sd = NULL) {
    if (!col %in% names(data)) return(list())
    out <- list(round(mean(data[[col]], na.rm = TRUE), 2))
    names(out) <- label_mean
    if (!is.null(label_sd)) {
      out[[label_sd]] <- round(stats::sd(data[[col]], na.rm = TRUE), 2)
    }
    out
  }

  summarise_one <- function(df) {
    s <- list(n_cows = nrow(df))

    s <- c(s, summarise_if_present(df, "days_in_milk",   "mean_dim"))
    s <- c(s, summarise_if_present(df, "milk_kg",        "mean_milk_kg",      "sd_milk_kg"))
    s <- c(s, summarise_if_present(df, "fat_percent",    "mean_fat_pct"))
    s <- c(s, summarise_if_present(df, "protein_percent","mean_protein_pct"))
    s <- c(s, summarise_if_present(df, "scc",            "mean_scc"))

    if ("mastitis" %in% names(df))
      s$mastitis_prev <- round(mean(df$mastitis, na.rm = TRUE), 3)

    if ("pregnant" %in% names(df))
      s$conception_rate <- round(mean(df$pregnant, na.rm = TRUE), 3)

    s <- c(s, summarise_if_present(df, "days_open",      "mean_days_open"))
    s <- c(s, summarise_if_present(df, "activity_score", "mean_activity"))

    tibble::as_tibble(s)
  }

  if (is.null(by)) {
    return(summarise_one(data))
  }

  missing <- setdiff(by, names(data))
  if (length(missing) > 0)
    stop("Grouping column(s) not found in data: ", paste(missing, collapse = ", "))

  groups  <- unique(data[by])
  results <- vector("list", nrow(groups))

  for (i in seq_len(nrow(groups))) {
    mask <- rep(TRUE, nrow(data))
    for (col in by) mask <- mask & (data[[col]] == groups[[col]][i])
    results[[i]] <- dplyr::bind_cols(groups[i, ], summarise_one(data[mask, ]))
  }

  dplyr::bind_rows(results)
}
