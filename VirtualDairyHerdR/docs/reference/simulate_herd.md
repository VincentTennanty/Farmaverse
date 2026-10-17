# Simulate a Dairy Herd

Generates a synthetic dairy herd with cow-level attributes. Can be
driven by a farm configuration object from
[`simulate_farm()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_farm.md).
Optionally expands the herd into a longitudinal dataset with one row per
cow per day of lactation (DIM 1–305).

## Usage

``` r
simulate_herd(n_cows = 100, farm = NULL, longitudinal = FALSE, seed = NULL)
```

## Arguments

- n_cows:

  Integer. Number of cows to generate. Overrides `farm$n_cows` if both
  are supplied. Default is 100.

- farm:

  A farm configuration list from
  [`simulate_farm()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_farm.md).
  Optional.

- longitudinal:

  Logical. If `TRUE`, expands each cow to one row per DIM (1–305),
  producing a time series tibble. Default is `FALSE`.

- seed:

  Integer. Random seed for reproducibility. Default is NULL.

## Value

A tibble with columns: `cow_id`, `breed`, `age`, `lactation`,
`days_in_milk`, `synthetic_data`, `source`. When `longitudinal = TRUE`,
each cow has 305 rows (one per DIM) and `days_in_milk` runs 1–305.

## Examples

``` r
# Snapshot herd
herd <- simulate_herd(100, seed = 42)

# Longitudinal herd — one row per cow per DIM
herd_long <- simulate_herd(20, longitudinal = TRUE, seed = 42)

farm <- simulate_farm(n_cows = 200, seed = 42)
herd <- simulate_herd(farm = farm)
```
