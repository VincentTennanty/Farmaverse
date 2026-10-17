# Simulate Milk Production

Generates daily milk yield, fat, protein, and somatic cell count for
each cow. Builds on the lactation curve from
[`simulate_lactation()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_lactation.md),
adding daily residual noise and milk composition.

## Usage

``` r
simulate_milk(herd, seed = NULL)
```

## Arguments

- herd:

  A tibble produced by
  [`simulate_herd()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_herd.md).

- seed:

  Integer. Random seed for reproducibility. Default is NULL.

## Value

The input tibble with additional columns: `milk_kg`, `fat_percent`,
`protein_percent`, `scc`.

## Details

- Milk yield uses Wood's curve via
  [`simulate_lactation()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_lactation.md)
  plus daily noise

- Fat and protein are negatively correlated with yield (dilution effect)

- SCC is log-normally distributed and increases slightly with DIM

## Examples

``` r
herd <- simulate_herd(100, seed = 1)
milk <- simulate_milk(herd, seed = 1)
```
