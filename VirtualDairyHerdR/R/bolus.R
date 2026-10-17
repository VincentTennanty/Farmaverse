#' Simulate Bolus Sensor Data
#'
#' Generates high-frequency synthetic bolus sensor data for each cow,
#' mimicking the output of internal bolus sensor platforms (e.g. SmaXtec).
#' Produces one row per cow per timestamp at a user-defined interval.
#'
#' @param herd A tibble produced by [simulate_herd()].
#' @param days Integer. Number of days of sensor data to generate per cow.
#'   Default is 30.
#' @param interval_mins Integer. Sensor recording interval in minutes.
#'   Default is 10.
#' @param start_date Date. Start date for the sensor records. Default is
#'   `Sys.Date()`.
#' @param seed Integer. Random seed for reproducibility. Default is NULL.
#'
#' @return A tibble with one row per cow per timestamp containing:
#' \describe{
#'   \item{cow_id}{Character. Links to [simulate_herd()] output.}
#'   \item{date}{Date. Calendar date of the reading.}
#'   \item{timestamp}{POSIXct. Date and time of the reading.}
#'   \item{dim_at_reading}{Integer. Days in milk on the date of the reading.}
#'   \item{bolus_temp}{Numeric. Internal body temperature (°C). Follows a
#'     circadian rhythm with spikes at mastitis and oestrus.}
#'   \item{rumination_mins}{Numeric. Rumination minutes in the interval.
#'     Peaks post-feeding; suppressed during mastitis and oestrus.}
#'   \item{activity_index}{Numeric. Activity level in the interval. Elevated
#'     during oestrus; suppressed during mastitis.}
#'   \item{oestrus}{Logical. TRUE if the cow is in oestrus on this day.}
#'   \item{mastitis}{Logical. TRUE if the cow has a mastitis event on this day.}
#' }
#'
#' @details
#' Biological patterns modelled:
#'
#' **Temperature** follows a circadian rhythm with a daily minimum around
#' 05:00 and maximum around 15:00 (amplitude ~0.5°C). Mastitis adds +0.5
#' to +2.5°C. Oestrus adds +0.3 to +0.8°C.
#'
#' **Rumination** peaks twice daily (~08:00 and ~20:00, post-feeding). It is
#' near zero during active oestrus and suppressed by 30–60% during mastitis.
#'
#' **Activity** declines gradually with DIM. A strong spike (2–3x baseline)
#' occurs over a 12–18 hour oestrus window. Mastitis suppresses activity by
#' 20–40%.
#'
#' **Oestrus** is assigned on a ~21-day cycle with a random phase per cow.
#' It is detectable from the combined activity spike and temperature rise —
#' mirroring real bolus platform alert logic.
#'
#' @examples
#' herd   <- simulate_herd(10, seed = 42)
#' bolus  <- simulate_bolus(herd, days = 7, seed = 42)
#'
#' # Custom interval
#' bolus15 <- simulate_bolus(herd, days = 7, interval_mins = 15, seed = 42)
#'
#' @export
simulate_bolus <- function(herd,
                           days          = 30,
                           interval_mins = 10,
                           start_date    = Sys.Date(),
                           seed          = NULL) {

  if (!is.null(seed)) set.seed(seed)

  readings_per_day <- as.integer(24 * 60 / interval_mins)
  n_cows           <- nrow(herd)

  # timestamps for one day — minutes from midnight
  mins_in_day <- seq(0, 1440 - interval_mins, by = interval_mins)
  hours_in_day <- mins_in_day / 60   # fractional hours 0–24

  # All dates
  dates <- seq.Date(as.Date(start_date), by = "day", length.out = days)

  # Build per-cow records
  results <- vector("list", n_cows)

  for (i in seq_len(n_cows)) {

    cow        <- herd[i, ]
    base_dim   <- cow$days_in_milk

    # Oestrus days — ~21 day cycle, random phase
    oestrus_phase <- sample(1:21, 1)
    oestrus_days  <- which((seq_len(days) + oestrus_phase) %% 21 == 0)

    # Mastitis days — low probability per day (~3%)
    mastitis_days <- which(stats::runif(days) < 0.03)

    # Per-cow random effects
    cow_temp_offset <- stats::rnorm(1, 0, 0.15)
    cow_rum_scale   <- stats::runif(1, 0.85, 1.15)
    cow_act_scale   <- stats::runif(1, 0.85, 1.15)

    day_list <- vector("list", days)

    for (d in seq_len(days)) {

      is_oestrus  <- d %in% oestrus_days
      is_mastitis <- d %in% mastitis_days
      dim_today   <- base_dim + d - 1L
      ts_date     <- dates[d]

      timestamps <- as.POSIXct(
        paste0(ts_date, " 00:00:00"), tz = "UTC"
      ) + mins_in_day * 60

      # ── Temperature ────────────────────────────────────────────────────────
      # Circadian: min ~05:00, max ~15:00
      circadian   <- 0.25 * sin(2 * pi * (hours_in_day - 5) / 24) +
                     0.25 * sin(2 * pi * (hours_in_day - 15) / 24)
      base_temp   <- 38.5 + cow_temp_offset + circadian
      temp_noise  <- stats::rnorm(readings_per_day, 0, 0.08)

      mastitis_temp_add <- if (is_mastitis)
        stats::runif(1, 0.5, 2.5) else 0
      oestrus_temp_add  <- if (is_oestrus)
        stats::runif(1, 0.3, 0.8) else 0

      bolus_temp <- round(base_temp + temp_noise +
                            mastitis_temp_add + oestrus_temp_add, 2)

      # ── Rumination ─────────────────────────────────────────────────────────
      # Two peaks: ~08:00 and ~20:00 (post-feeding)
      rum_pattern <- 0.5 * exp(-0.5 * ((hours_in_day - 8)  / 1.5) ^ 2) +
                     0.5 * exp(-0.5 * ((hours_in_day - 20) / 1.5) ^ 2)
      rum_pattern <- rum_pattern / max(rum_pattern)

      # Max rumination per interval scales with interval length
      max_rum_per_interval <- interval_mins * 0.65 * cow_rum_scale

      base_rum   <- rum_pattern * max_rum_per_interval
      rum_noise  <- stats::rnorm(readings_per_day, 0, max_rum_per_interval * 0.05)

      mastitis_rum_mult <- if (is_mastitis) stats::runif(1, 0.40, 0.70) else 1
      oestrus_rum_mult  <- if (is_oestrus)  stats::runif(1, 0.05, 0.20) else 1

      rumination_mins <- round(pmax(
        (base_rum + rum_noise) * mastitis_rum_mult * oestrus_rum_mult, 0), 2)

      # ── Activity ───────────────────────────────────────────────────────────
      # Declines with DIM; peaks during oestrus over 12–18hr window
      dim_decay    <- pmax(1 - 0.001 * dim_today, 0.4)
      base_act     <- stats::rnorm(readings_per_day,
                                   mean = 20 * dim_decay * cow_act_scale,
                                   sd   = 4)

      # Oestrus window — centred around hour 12, 12–18hr duration
      oestrus_window_hrs <- if (is_oestrus) stats::runif(1, 12, 18) else 0
      oestrus_centre     <- 12
      oestrus_mult <- if (is_oestrus) {
        in_window <- abs(hours_in_day - oestrus_centre) < oestrus_window_hrs / 2
        ifelse(in_window, stats::runif(1, 2.0, 3.0), 1)
      } else rep(1, readings_per_day)

      mastitis_act_mult <- if (is_mastitis) stats::runif(1, 0.60, 0.80) else 1

      activity_index <- round(pmax(
        base_act * oestrus_mult * mastitis_act_mult, 0), 2)

      day_list[[d]] <- tibble::tibble(
        cow_id         = cow$cow_id,
        date           = ts_date,
        timestamp      = timestamps,
        dim_at_reading = dim_today,
        bolus_temp     = bolus_temp,
        rumination_mins = rumination_mins,
        activity_index = activity_index,
        oestrus        = is_oestrus,
        mastitis       = is_mastitis
      )
    }

    results[[i]] <- dplyr::bind_rows(day_list)
  }

  dplyr::bind_rows(results)
}
