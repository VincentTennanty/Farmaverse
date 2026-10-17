# VirtualDairyHerdR: A Digital Dairy Herd Simulator for Education, Research and Precision Livestock Farming

VirtualDairyHerdR generates biologically realistic synthetic dairy herd
datasets for teaching statistics, data wrangling, visualisation, and
machine learning in agricultural and precision livestock farming
contexts.

It is part of the
[Farmaverse](https://github.com/VincentTennanty/Farmaverse) — an open
ecosystem of R livestock simulation packages inspired by the
[pharmaverse](https://pharmaverse.org/).

## Simulation pipeline

Functions are designed to chain together, each accepting the output of
the previous step and adding columns:

    simulate_farm()
        └── simulate_herd()
                ├── simulate_milk()
                │       ├── simulate_mastitis()
                │       └── simulate_fertility()
                └── simulate_activity()

## Main functions

- [`simulate_farm()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_farm.md):

  Create a farm-level configuration object.

- [`simulate_herd()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_herd.md):

  Generate a synthetic dairy herd.

- [`simulate_lactation()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_lactation.md):

  Wood's lactation curve engine.

- [`simulate_milk()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_milk.md):

  Daily milk yield, fat, protein, and SCC.

- [`simulate_mastitis()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_mastitis.md):

  Mastitis disease effects and labels.

- [`simulate_fertility()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_fertility.md):

  Conception probability and days open.

- [`simulate_activity()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_activity.md):

  Activity score, steps, lying/standing time.

- [`education_summary()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/education_summary.md):

  Flexible grouped summary table.

## Bundled datasets

- [demo_herd](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/demo_herd.md):

  200-cow synthetic herd with milk production data.

- [demo_mastitis](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/demo_mastitis.md):

  Same herd with mastitis labels at 15% prevalence.

## Design principles

1.  Biologically grounded — parameters drawn from published dairy
    science literature and real sensor platform experience.

2.  Pipeline-first — every function accepts the output of the previous
    step and adds columns.

3.  Education-ready — datasets designed to support teaching statistics,
    data wrangling, visualisation, and machine learning.

4.  Transparent — all simulation logic is open, documented, and
    auditable.

5.  Interoperable — standard tibbles; works with tidyverse, ggplot2,
    caret, tidymodels, and mlr3.

## Reproducibility

Every simulation function accepts a `seed` argument. Pass the same seed
to reproduce identical datasets across sessions. All outputs carry
`synthetic_data = TRUE` so they can never be mistaken for real farm
records.

## References

Wood, P.D.P. (1967). Algebraic model of the lactation curve in cattle.
*Nature*, 216, 164–165.

## See also

- Farmaverse: <https://github.com/VincentTennanty/Farmaverse>

- Vignette:
  [`vignette("introduction", package = "VirtualDairyHerdR")`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/articles/introduction.md)

## Author

Vincent Tennanty <Vinny93@live.co.uk>
