# VirtualDairyHerdR News

## VirtualDairyHerdR 0.1.0 (2026-10-17)

### Initial release

First public release of VirtualDairyHerdR as part of the Farmaverse ecosystem.

#### New functions

- `simulate_farm()` — create a farm-level configuration object (name, location, system, herd size)
- `simulate_herd()` — generate a synthetic dairy herd with breed, parity, age, and DIM
- `simulate_lactation()` — Wood's lactation curve engine with breed and parity adjustments
- `simulate_milk()` — daily milk yield, fat %, protein %, and SCC built on the lactation curve
- `simulate_mastitis()` — mastitis disease effects; labelled dataset ready for ML classification
- `simulate_fertility()` — logistic conception model driven by parity, DIM, and the production-fertility antagonism
- `simulate_activity()` — activity score, steps, lying and standing minutes (always sum to 1440)
- `education_summary()` — flexible grouped summary table; group by breed, lactation, or any column

#### Datasets

- `demo_herd` — a pre-built synthetic herd of 200 cows for quick exploration
- `demo_mastitis` — a pre-built mastitis dataset ready for classification exercises

#### Notes

- All functions accept a `seed` argument for full reproducibility
- All outputs carry `synthetic_data = TRUE`
- Pipeline design: every function accepts the output of the previous step and adds columns
