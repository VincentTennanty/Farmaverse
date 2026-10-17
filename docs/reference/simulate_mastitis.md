# Simulate Mastitis Events

Applies mastitis disease effects to a milk dataset, generating a
labelled dataset suitable for machine learning classification exercises.

## Usage

``` r
simulate_mastitis(milk, prevalence = 0.15, seed = NULL)
```

## Arguments

- milk:

  A tibble produced by
  [`simulate_milk()`](https://vincenttennanty.github.io/Farmaverse/reference/simulate_milk.md).

- prevalence:

  Numeric. Proportion of cows with mastitis (0–1). Default is 0.15.

- seed:

  Integer. Random seed for reproducibility. Default is NULL.

## Value

The input tibble with additional columns: `temperature`,
`rumination_minutes`, `mastitis` (logical).

## Details

Mastitis effects applied to cases:

- Milk yield reduced by 15–40%

- SCC elevated 5–20x

- Body temperature increased +0.5 to +2.5 °C

- Rumination reduced by 20–50%

## Examples

``` r
herd <- simulate_herd(100, seed = 1)
milk <- simulate_milk(herd, seed = 1)
health <- simulate_mastitis(milk, prevalence = 0.15, seed = 1)
```
