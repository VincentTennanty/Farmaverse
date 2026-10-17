# VirtualDairyHerdR

> Simulate biologically realistic synthetic dairy herd datasets for
> education, research, and precision livestock farming.

Part of the
[**Farmaverse**](https://github.com/VincentTennanty/Farmaverse) — an
open ecosystem of R livestock simulation packages inspired by the
[pharmaverse](https://pharmaverse.org/).

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

------------------------------------------------------------------------

## What is VirtualDairyHerdR?

VirtualDairyHerdR generates synthetic, farm-ready dairy herd datasets
that mirror the structure and biology of real precision livestock
farming data — without requiring access to proprietary farm records.

It is designed for:

- **Educators** teaching statistics, data wrangling, and machine
  learning in an agricultural context
- **Researchers** who need realistic training data without farm data
  access agreements
- **Data scientists** building and benchmarking PLF models
- **Students** learning R with domain-relevant datasets

Every dataset carries `synthetic_data = TRUE` so it can never be
mistaken for real farm records.

------------------------------------------------------------------------

## Installation

``` r

# Development version from GitHub
devtools::install_github("VincentTennanty/Farmaverse/VirtualDairyHerdR")
```

------------------------------------------------------------------------

## Quick start

``` r

library(VirtualDairyHerdR)

farm     <- simulate_farm(name = "Greenfield Farm", n_cows = 200, seed = 42)
herd     <- simulate_herd(farm = farm)
milk     <- simulate_milk(herd, seed = 42)
health   <- simulate_mastitis(milk, prevalence = 0.15, seed = 42)
fert     <- simulate_fertility(milk, seed = 42)
activity <- simulate_activity(herd, seed = 42)

# Grouped summary by breed and lactation number
education_summary(fert, by = c("breed", "lactation"))
```

------------------------------------------------------------------------

## Simulation pipeline

    simulate_farm()
        └── simulate_herd()
                ├── simulate_milk()
                │       ├── simulate_mastitis()   # binary classification dataset
                │       └── simulate_fertility()  # days open, conception rate
                └── simulate_activity()           # steps, lying/standing time

Every function accepts the output of the previous step and adds columns.
Enter or exit the pipeline at any stage.

------------------------------------------------------------------------

## Functions

| Function | Input | Key outputs |
|----|----|----|
| [`simulate_farm()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_farm.md) | — | Farm config list |
| [`simulate_herd()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_herd.md) | farm | `cow_id`, `breed`, `lactation`, `days_in_milk` |
| [`simulate_lactation()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_lactation.md) | herd | `wood_a`, `wood_b`, `wood_c`, `peak_yield`, `predicted_yield` |
| [`simulate_milk()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_milk.md) | herd | `milk_kg`, `fat_percent`, `protein_percent`, `scc` |
| [`simulate_mastitis()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_mastitis.md) | milk | `temperature`, `rumination_minutes`, `mastitis` |
| [`simulate_fertility()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_fertility.md) | milk | `pregnant`, `days_open`, `conception_attempt` |
| [`simulate_activity()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/simulate_activity.md) | herd | `activity_score`, `steps`, `lying_minutes`, `standing_minutes` |
| [`education_summary()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/education_summary.md) | any | Grouped summary tibble |

------------------------------------------------------------------------

## Key features

- **Wood’s lactation curve** engine with breed and parity adjustments
- **Mastitis simulation** — elevated SCC, reduced yield and rumination,
  raised temperature; labelled dataset ready for binary ML
  classification
- **Fertility model** — logistic conception probability driven by
  parity, DIM, and the production–fertility antagonism
- **Activity sensors** — steps, activity score, lying/standing minutes
  modelled on real bolus and collar sensor output; lying + standing
  always sum to 1440
- **[`education_summary()`](https://vincenttennanty.github.io/Farmaverse/VirtualDairyHerdR/reference/education_summary.md)**
  — flexible grouped summaries by breed, lactation, DIM band, or any
  column in the data
- Full **reproducibility** via `seed` arguments throughout
- **Pipeline-first design** — standard tibble outputs; works with
  tidyverse, ggplot2, caret, tidymodels, and mlr3

------------------------------------------------------------------------

## Design principles

1.  **Biologically grounded** — parameters drawn from published dairy
    science literature and real sensor platform experience, not
    arbitrary distributions
2.  **Pipeline-first** — every function accepts the output of the
    previous step and adds columns; enter or exit at any stage
3.  **Education-ready** — datasets designed to support teaching
    statistics, data wrangling, visualisation, and machine learning
4.  **Transparent** — all simulation logic is open, documented, and
    auditable
5.  **Interoperable** — standard tibbles; works seamlessly with the
    tidyverse

------------------------------------------------------------------------

## Learn more

``` r

vignette("introduction", package = "VirtualDairyHerdR")
```

------------------------------------------------------------------------

## Contributing

VirtualDairyHerdR is part of the broader Farmaverse ecosystem.
Contributions are welcome — from parameter improvements grounded in
published literature to entirely new simulation modules (lameness,
ketosis, calving records).

See the [Farmaverse contributing
guide](https://github.com/VincentTennanty/Farmaverse#-contributing--we-need-you).

------------------------------------------------------------------------

## Citation

    Tennanty V. (2026). VirtualDairyHerdR: A Digital Dairy Herd Simulator for
    Education, Research and Precision Livestock Farming. R package version 0.1.0.
    https://github.com/VincentTennanty/Farmaverse

------------------------------------------------------------------------

## About the author

VirtualDairyHerdR was created by **Vincent Tennanty**, a Cork-based data
scientist with a background spanning precision livestock farming and
global pharmaceutical technology.

Vincent has worked as a **Technical Lead in a global pharma company**,
where he gained deep experience in regulated data pipelines,
reproducible analysis, and the kind of opinionated, interoperable
tooling that the [pharmaverse](https://pharmaverse.org/) exemplifies.
That experience is the direct inspiration for the Farmaverse — the
belief that agricultural data science deserves the same rigour and open
infrastructure that clinical data science has built.

On the livestock side, Vincent has hands-on experience with **precision
dairy technology**, having worked with commercial cow sensor platforms
including **SmaXtec** and **SensHub** — bolus and collar-based systems
that generate the exact kind of continuous health, activity, and
rumination data that VirtualDairyHerdR is designed to simulate. That
real-world sensor experience shapes every parameter in the package: the
activity score distributions, the rumination suppression in mastitis
cases, the lying/standing time windows — all grounded in what these
systems actually produce on Irish grass-based farms.

------------------------------------------------------------------------

## License

MIT © Vincent Tennanty 2026
