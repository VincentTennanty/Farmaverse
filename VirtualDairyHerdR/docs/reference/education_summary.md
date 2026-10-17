# Summarise a Virtual Herd Dataset

Produces a grouped summary table from any stage of the simulation
pipeline. Designed for teaching — students can aggregate by herd, breed,
lactation number, or any other grouping variable present in the data.

## Usage

``` r
education_summary(data, by = NULL)
```

## Arguments

- data:

  A tibble from any simulation step (e.g.
  [`simulate_milk()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_milk.md),
  [`simulate_mastitis()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_mastitis.md),
  [`simulate_fertility()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_fertility.md)).

- by:

  Character vector of column names to group by. Default is `NULL`
  (whole-herd summary). Common options: `"breed"`, `"lactation"`,
  `c("breed", "lactation")`.

## Value

A tibble with one row per group containing summary statistics for
whichever of the following columns are present in `data`: `milk_kg`,
`fat_percent`, `protein_percent`, `scc`, `days_in_milk`, `pregnant`,
`days_open`, `activity_score`, `mastitis`.

## Examples

``` r
herd <- simulate_herd(100, seed = 1)
milk <- simulate_milk(herd, seed = 1)

# Whole-herd summary
education_summary(milk)
#> # A tibble: 1 × 7
#>   n_cows mean_dim mean_milk_kg sd_milk_kg mean_fat_pct mean_protein_pct mean_scc
#>    <int>    <dbl>        <dbl>      <dbl>        <dbl>            <dbl>    <dbl>
#> 1    100     157.         32.7       7.91         3.54             3.06     131.

# By breed
education_summary(milk, by = "breed")
#> # A tibble: 4 × 8
#>   breed    n_cows mean_dim mean_milk_kg sd_milk_kg mean_fat_pct mean_protein_pct
#>   <chr>     <int>    <dbl>        <dbl>      <dbl>        <dbl>            <dbl>
#> 1 Friesian     38     155.         35.2       7.5          3.47             3.04
#> 2 Holstein     40     152.         32.9       7.42         3.56             3.06
#> 3 Crossbr…      9     148.         33.0       7.32         3.55             3.03
#> 4 Jersey       13     184.         24.3       5.59         3.66             3.19
#> # ℹ 1 more variable: mean_scc <dbl>

# By lactation number
education_summary(milk, by = "lactation")
#> # A tibble: 6 × 8
#>   lactation n_cows mean_dim mean_milk_kg sd_milk_kg mean_fat_pct
#>       <int>  <int>    <dbl>        <dbl>      <dbl>        <dbl>
#> 1         2     25     171.         31.8       8.7          3.62
#> 2         3     21     167.         31.6       8            3.52
#> 3         5     12     176.         30.5       9.01         3.5 
#> 4         1     20     130.         36.2       7.61         3.38
#> 5         6      4     141.         34.8       6.64         3.56
#> 6         4     18     146.         32.2       5.96         3.63
#> # ℹ 2 more variables: mean_protein_pct <dbl>, mean_scc <dbl>

# By breed and lactation
education_summary(milk, by = c("breed", "lactation"))
#> # A tibble: 20 × 9
#>    breed     lactation n_cows mean_dim mean_milk_kg sd_milk_kg mean_fat_pct
#>    <chr>         <int>  <int>    <dbl>        <dbl>      <dbl>        <dbl>
#>  1 Friesian          2      8     170.         36.5       8.53         3.55
#>  2 Holstein          2     11     134.         32.8       7.56         3.56
#>  3 Holstein          3     10     175.         29.7       3.24         3.5 
#>  4 Crossbred         5      3     117.         34.2       8.93         3.55
#>  5 Friesian          1     13     143.         35.3       7.33         3.35
#>  6 Holstein          5      4     242.         31.5      12.2          3.54
#>  7 Holstein          6      2      45          40.4       2.24         3.3 
#>  8 Friesian          3      8     178.         35.9       9.97         3.48
#>  9 Crossbred         3      1      35          37.3      NA            3.89
#> 10 Crossbred         1      2      93          38.5       6.11         3.08
#> 11 Holstein          4      8     155.         33.2       6.69         3.7 
#> 12 Friesian          4      6     129.         33.8       4.82         3.56
#> 13 Crossbred         6      2     238.         29.2       0.38         3.83
#> 14 Holstein          1      5     110.         37.3       9.87         3.55
#> 15 Jersey            2      6     239          23.7       5.58         3.81
#> 16 Crossbred         4      1     280          22.0      NA            3.57
#> 17 Friesian          5      3     157.         32.0       5.17         3.49
#> 18 Jersey            4      3     114.         29.6       3.72         3.59
#> 19 Jersey            3      2     148.         21.3       8.03         3.64
#> 20 Jersey            5      2     162          21.0       1.26         3.34
#> # ℹ 2 more variables: mean_protein_pct <dbl>, mean_scc <dbl>
```
