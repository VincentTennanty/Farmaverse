# Simulate Bolus Sensor Data

Generates high-frequency synthetic bolus sensor data for each cow,
mimicking the output of internal bolus sensor platforms (e.g. SmaXtec).
Produces one row per cow per timestamp at a user-defined interval.

## Usage

``` r
simulate_bolus(
  herd,
  days = 30,
  interval_mins = 10,
  start_date = Sys.Date(),
  seed = NULL
)
```

## Arguments

- herd:

  A tibble produced by
  [`simulate_herd()`](https://vincenttennanty.github.io/Farmaverse/reference/simulate_herd.md).

- days:

  Integer. Number of days of sensor data to generate per cow. Default is
  30.

- interval_mins:

  Integer. Sensor recording interval in minutes. Default is 10.

- start_date:

  Date. Start date for the sensor records. Default is
  [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html).

- seed:

  Integer. Random seed for reproducibility. Default is NULL.

## Value

A tibble with one row per cow per timestamp containing:

- cow_id:

  Character. Links to
  [`simulate_herd()`](https://vincenttennanty.github.io/Farmaverse/reference/simulate_herd.md)
  output.

- date:

  Date. Calendar date of the reading.

- timestamp:

  POSIXct. Date and time of the reading.

- dim_at_reading:

  Integer. Days in milk on the date of the reading.

- bolus_temp:

  Numeric. Internal body temperature (°C). Follows a circadian rhythm
  with spikes at mastitis and oestrus.

- rumination_mins:

  Numeric. Rumination minutes in the interval. Peaks post-feeding;
  suppressed during mastitis and oestrus.

- activity_index:

  Numeric. Activity level in the interval. Elevated during oestrus;
  suppressed during mastitis.

- oestrus:

  Logical. TRUE if the cow is in oestrus on this day.

- mastitis:

  Logical. TRUE if the cow has a mastitis event on this day.

## Details

Biological patterns modelled:

**Temperature** follows a circadian rhythm with a daily minimum around
05:00 and maximum around 15:00 (amplitude ~0.5°C). Mastitis adds +0.5 to
+2.5°C. Oestrus adds +0.3 to +0.8°C.

**Rumination** peaks twice daily (~08:00 and ~20:00, post-feeding). It
is near zero during active oestrus and suppressed by 30–60% during
mastitis.

**Activity** declines gradually with DIM. A strong spike (2–3x baseline)
occurs over a 12–18 hour oestrus window. Mastitis suppresses activity by
20–40%.

**Oestrus** is assigned on a ~21-day cycle with a random phase per cow.
It is detectable from the combined activity spike and temperature rise —
mirroring real bolus platform alert logic.

## Examples

``` r
herd   <- simulate_herd(10, seed = 42)
bolus  <- simulate_bolus(herd, days = 7, seed = 42)

# Custom interval
bolus15 <- simulate_bolus(herd, days = 7, interval_mins = 15, seed = 42)
```
