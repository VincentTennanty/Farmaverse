# data-raw/generate_demo_data.R
#
# This script generates the demo datasets bundled with VirtualDairyHerdR.
# Run this script manually to regenerate the .rda files in data/.
#
# usethis::use_data_raw() convention — run from the package root:
#   source("data-raw/generate_demo_data.R")

library(VirtualDairyHerdR)

# ── demo_herd ─────────────────────────────────────────────────────────────────
# A 200-cow synthetic herd with milk production data.
# Suitable for general exploration, visualisation, and regression exercises.

farm      <- simulate_farm(name = "Greenfield Farm", n_cows = 200, seed = 42)
herd      <- simulate_herd(farm = farm)
demo_herd <- simulate_milk(herd, seed = 42)

usethis::use_data(demo_herd, overwrite = TRUE)

# ── demo_mastitis ─────────────────────────────────────────────────────────────
# The same herd with mastitis labels applied at 15% prevalence.
# Suitable for binary classification exercises (mastitis ~ .).

demo_mastitis <- simulate_mastitis(demo_herd, prevalence = 0.15, seed = 42)

usethis::use_data(demo_mastitis, overwrite = TRUE)
