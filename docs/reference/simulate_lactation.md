# Simulate Lactation Curves

Generates cow-level Wood's lactation curve parameters and predicted
daily milk yield for each cow's current days in milk. This is the
biological engine underlying
[`simulate_milk()`](https://vincenttennanty.github.io/Farmaverse/reference/simulate_milk.md).

## Usage

``` r
simulate_lactation(herd, seed = NULL)
```

## Arguments

- herd:

  A tibble produced by
  [`simulate_herd()`](https://vincenttennanty.github.io/Farmaverse/reference/simulate_herd.md).

- seed:

  Integer. Random seed for reproducibility. Default is NULL.

## Value

The input tibble with additional columns: `wood_a`, `wood_b`, `wood_c`,
`peak_dim`, `peak_yield`, `predicted_yield`.

## Details

Wood's model: `Y = a * DIM^b * exp(-c * DIM)`

- `wood_a` — scale parameter (drives overall yield level)

- `wood_b` — inclining slope (time to peak)

- `wood_c` — declining slope (persistency)

- `peak_dim` — predicted day of peak yield = `b / c`

- `peak_yield` — predicted peak yield in kg

Breed and lactation adjustments are applied to `wood_a`. Individual
cow-level random effects are added to all three parameters.

## Examples

``` r
herd <- simulate_herd(100, seed = 1)
lact <- simulate_lactation(herd, seed = 1)
```
