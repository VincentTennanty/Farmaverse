# Simulate Activity Sensor Data

Generates synthetic daily activity sensor readings for each cow,
including activity score, steps, and lying/standing time.

## Usage

``` r
simulate_activity(herd, seed = NULL)
```

## Arguments

- herd:

  A tibble produced by
  [`simulate_herd()`](https://vincenttennanty.github.io/Farmaverse/reference/simulate_herd.md).

- seed:

  Integer. Random seed for reproducibility. Default is NULL.

## Value

The input tibble with additional columns: `activity_score`, `steps`,
`lying_minutes`, `standing_minutes`.

## Details

- Lying and standing minutes always sum to 1440 (24 hours)

- Activity is higher in early lactation and declines with DIM

- Steps are positively correlated with activity score

## Examples

``` r
herd <- simulate_herd(100, seed = 1)
activity <- simulate_activity(herd, seed = 1)
```
