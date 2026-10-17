# Simulate Fertility Records

Generates cow-level fertility outcomes. Conception probability is
influenced by lactation number, days in milk, and milk yield (high
producers are harder to get in calf — the production-fertility
antagonism).

## Usage

``` r
simulate_fertility(milk, seed = NULL)
```

## Arguments

- milk:

  A tibble produced by
  [`simulate_milk()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_milk.md)
  or
  [`simulate_mastitis()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_mastitis.md).

- seed:

  Integer. Random seed for reproducibility. Default is NULL.

## Value

The input tibble with additional columns: `days_to_first_service`,
`conception_attempt`, `pregnant`, `days_open`.

## Details

Conception probability is modelled as a logistic function of:

- Lactation number (parity penalty for older cows)

- Days in milk at first service (optimal window ~50–80 DIM)

- Milk yield (negative effect — dilution of energy balance)

- `days_to_first_service` — voluntary waiting period + noise (~42–70
  days)

- `conception_attempt` — number of services to conception (1–4), or NA
  if open

- `pregnant` — logical; TRUE if cow conceived

- `days_open` — days from calving to conception; NA if not pregnant

## Examples

``` r
herd <- simulate_herd(100, seed = 1)
milk <- simulate_milk(herd, seed = 1)
fert <- simulate_fertility(milk, seed = 1)
```
