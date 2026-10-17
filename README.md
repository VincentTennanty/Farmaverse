# Farmaverse <img src="VirtualDairyHerdR/man/figures/logo.png" align="right" height="140" />

> A collection of R packages for simulating biologically realistic synthetic
> livestock datasets — built for education, research, and precision livestock
> farming.

---

## What is the Farmaverse?

The Farmaverse is an open ecosystem of R simulation packages for livestock
species. Each package generates synthetic, farm-ready datasets that mirror the
structure and biology of real precision livestock farming (PLF) data — without
requiring access to proprietary farm records.

The packages are designed to slot together naturally: a common pipeline
philosophy, consistent column naming conventions, and a shared `synthetic_data`
flag so downstream code always knows what it's working with.

---

## Inspiration

The Farmaverse is directly inspired by the
[**pharmaverse**](https://pharmaverse.org/) — a curated collection of R
packages that support clinical reporting workflows in the pharmaceutical
industry. The pharmaverse demonstrated that a domain-specific, opinionated
ecosystem of interoperable packages can dramatically lower the barrier to
reproducible, high-quality analysis in a regulated field.

We believe precision livestock farming deserves the same. Agricultural data
science is growing rapidly, but access to realistic training datasets remains a
bottleneck for educators, students, and researchers. The Farmaverse aims to
close that gap — one species at a time.

---

## Packages

| Package | Species | Status | Description |
|---|---|---|---|
| [**VirtualDairyHerdR**](./VirtualDairyHerdR) | 🐄 Dairy Cattle | ✅ Active | Simulate milk production, mastitis, fertility, activity sensors and lactation curves for a dairy herd |
| [**VirtualBeefHerdR**](./VirtualBeefHerdR) | 🐂 Beef Cattle | 🔜 Planned | Growth curves, weight gain, health events, and finishing performance for beef cattle |
| [**VirtualSheepFlockR**](./VirtualSheepFlockR) | 🐑 Sheep | 🔜 Planned | Lambing records, body condition scoring, parasite burden, and flock-level reproductive performance |
| [**VirtualBroilerFlockR**](./VirtualBroilerFlockR) | 🐔 Broiler Poultry | 🔜 Planned | Daily liveweight, feed conversion ratio, mortality, and flock uniformity for broiler production |

---

## VirtualDairyHerdR — Quick Start

```r
# Install (development)
# devtools::install_github("VincentTennanty/Farmaverse/VirtualDairyHerdR")

library(VirtualDairyHerdR)

# Build a full synthetic herd in one pipeline
farm     <- simulate_farm(name = "Greenfield Farm", n_cows = 200, seed = 42)
herd     <- simulate_herd(farm = farm)
milk     <- simulate_milk(herd, seed = 42)
health   <- simulate_mastitis(milk, prevalence = 0.15, seed = 42)
fert     <- simulate_fertility(milk, seed = 42)
activity <- simulate_activity(herd, seed = 42)

# Summarise by breed and lactation number
education_summary(fert, by = c("breed", "lactation"))
```

### Simulation pipeline

```
simulate_farm()
    └── simulate_herd()
            ├── simulate_milk()
            │       ├── simulate_mastitis()   # binary classification dataset
            │       └── simulate_fertility()  # days open, conception rate
            └── simulate_activity()           # steps, lying/standing time
```

### Key features

- **Wood's lactation curve** engine with breed and parity adjustments
- **Mastitis simulation** — elevated SCC, reduced yield and rumination, raised temperature; ready for ML classification
- **Fertility model** — logistic conception probability driven by parity, DIM, and the production–fertility antagonism
- **Activity sensors** — steps, activity score, lying/standing minutes (always sum to 1440)
- **`education_summary()`** — flexible grouped summaries by breed, lactation, DIM band, or any column in the data
- Full **reproducibility** via `seed` arguments throughout
- Every dataset carries `synthetic_data = TRUE` so it can never be mistaken for real farm records

---

## Design principles

1. **Biologically grounded** — parameters are drawn from published dairy science literature, not arbitrary distributions
2. **Pipeline-first** — every function accepts the output of the previous step and adds columns; enter or exit at any stage
3. **Education-ready** — datasets are designed to support teaching statistics, data wrangling, visualisation, and machine learning
4. **Transparent** — all simulation logic is open, documented, and auditable
5. **Interoperable** — outputs are standard tibbles; works seamlessly with tidyverse, ggplot2, caret, tidymodels, and mlr3

---

## 🤝 Contributing — We Need You

The Farmaverse is only as good as the biology behind it. We are actively
looking for contributors with domain expertise to help build out the planned
packages and improve the existing ones.

### We are especially looking for people who can help with:

**VirtualBeefHerdR**
- Growth curve models (Gompertz, Richards, or Von Bertalanffy)
- Realistic weight gain trajectories by breed and sex
- Health events: BRD, lameness, liver fluke
- Finishing performance: kill-out %, carcass grade

**VirtualSheepFlockR**
- Lambing records: litter size, lamb survival, birth weight by breed
- Body condition score trajectories across the production year
- Nematode/parasite burden models (FAMACHA, FEC)
- Flock-level reproductive KPIs: scanning %, lambing %, weaning %

**VirtualBroilerFlockR**
- Daily liveweight curves by strain and sex
- Feed conversion ratio (FCR) simulation
- Flock uniformity (coefficient of variation)
- Mortality patterns: early chick mortality, late-stage condemnations

**VirtualDairyHerdR (improvements)**
- Lameness simulation (mobility scoring, DIM at onset)
- Ketosis / negative energy balance indicators (fat:protein ratio, BHB)
- Calving records and dry cow management
- Seasonal calving patterns (spring-block vs. year-round)

### How to contribute

1. Open an issue on [GitHub](https://github.com/VincentTennanty/Farmaverse/issues) describing the biological model you want to add
2. Fork the repo and create a branch: `git checkout -b feature/beef-growth-curve`
3. Follow the existing function style — roxygen2 docs, `seed` argument, returns a tibble with `synthetic_data = TRUE`
4. Submit a pull request — all contributions welcome, from parameter tweaks to full new simulation functions

If you are a researcher, vet, farm consultant, or data scientist with livestock
domain knowledge and want to collaborate, please open an issue or reach out
directly. You don't need to be an R expert — if you can describe the biology,
we can help with the code.

---

## Citation

If you use any Farmaverse package in teaching or research, please cite it:

```
Tennanty V. (2024). VirtualDairyHerdR: A Digital Dairy Herd Simulator for
Education, Research and Precision Livestock Farming. R package version 0.1.0.
https://github.com/VincentTennanty/Farmaverse
```

---

## License

MIT © Vincent Tennanty. See individual package `LICENSE` files for details.
