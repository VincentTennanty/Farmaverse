library(testthat)
library(VirtualDairyHerdR)

# ── Fixtures ──────────────────────────────────────────────────────────────────
farm  <- simulate_farm(n_cows = 50, seed = 42)
herd  <- simulate_herd(farm = farm)
milk  <- simulate_milk(herd, seed = 42)
mast  <- simulate_mastitis(milk, prevalence = 0.15, seed = 42)
fert  <- simulate_fertility(milk, seed = 42)
act   <- simulate_activity(herd, seed = 42)

# ── simulate_farm ─────────────────────────────────────────────────────────────
test_that("simulate_farm returns correct structure", {
  expect_type(farm, "list")
  expect_equal(farm$n_cows, 50)
  expect_equal(farm$system, "grass-based")
  expect_true(farm$synthetic_data)
})

test_that("simulate_farm rejects invalid system", {
  expect_error(simulate_farm(system = "indoor"))
})

# ── simulate_herd ─────────────────────────────────────────────────────────────
test_that("simulate_herd returns correct dimensions and columns", {
  expect_s3_class(herd, "tbl_df")
  expect_equal(nrow(herd), 50)
  expect_true(all(c("cow_id", "breed", "age", "lactation",
                    "days_in_milk") %in% names(herd)))
})

test_that("simulate_herd values are in valid ranges", {
  expect_true(all(herd$lactation >= 1 & herd$lactation <= 6))
  expect_true(all(herd$days_in_milk >= 1 & herd$days_in_milk <= 305))
  expect_true(all(herd$breed %in% c("Holstein", "Friesian", "Jersey", "Crossbred")))
})

test_that("simulate_herd respects farm n_cows", {
  expect_equal(nrow(herd), farm$n_cows)
})

test_that("simulate_herd longitudinal expands to n_cows * 305 rows", {
  herd_long <- simulate_herd(n_cows = 10, longitudinal = TRUE, seed = 42)
  expect_equal(nrow(herd_long), 10 * 305)
  expect_true(all(herd_long$days_in_milk %in% 1:305))
  expect_equal(length(unique(herd_long$cow_id)), 10)
})

# ── simulate_lactation ────────────────────────────────────────────────────────
test_that("simulate_lactation adds Wood's curve columns", {
  lact <- simulate_lactation(herd, seed = 42)
  expect_true(all(c("wood_a", "wood_b", "wood_c",
                    "peak_dim", "peak_yield", "predicted_yield") %in% names(lact)))
  expect_true(all(lact$wood_a > 0))
  expect_true(all(lact$predicted_yield >= 0.5))
})

# ── simulate_milk ─────────────────────────────────────────────────────────────
test_that("simulate_milk adds milk composition columns", {
  expect_true(all(c("milk_kg", "fat_percent",
                    "protein_percent", "scc") %in% names(milk)))
})

test_that("simulate_milk values are biologically plausible", {
  expect_true(all(milk$milk_kg >= 0.5))
  expect_true(all(milk$fat_percent >= 2.0))
  expect_true(all(milk$protein_percent >= 2.0))
  expect_true(all(milk$scc > 0))
})

# ── simulate_mastitis ─────────────────────────────────────────────────────────
test_that("simulate_mastitis adds health columns", {
  expect_true(all(c("temperature", "rumination_minutes", "mastitis") %in% names(mast)))
  expect_type(mast$mastitis, "logical")
})

test_that("simulate_mastitis prevalence is approximately correct", {
  prev <- mean(mast$mastitis)
  expect_true(prev >= 0.0 & prev <= 0.5)   # wide tolerance for n=50
})

test_that("mastitis cases have elevated SCC and temperature", {
  cases    <- mast[mast$mastitis, ]
  controls <- mast[!mast$mastitis, ]
  if (nrow(cases) > 0 && nrow(controls) > 0) {
    expect_true(mean(cases$scc) > mean(controls$scc))
    expect_true(mean(cases$temperature) > mean(controls$temperature))
  }
})

# ── simulate_fertility ────────────────────────────────────────────────────────
test_that("simulate_fertility adds fertility columns", {
  expect_true(all(c("days_to_first_service", "conception_attempt",
                    "pregnant", "days_open") %in% names(fert)))
  expect_type(fert$pregnant, "logical")
})

test_that("simulate_fertility days_to_first_service >= 42", {
  expect_true(all(fert$days_to_first_service >= 42))
})

test_that("simulate_fertility days_open is NA for non-pregnant cows", {
  expect_true(all(is.na(fert$days_open[!fert$pregnant])))
  expect_true(all(is.na(fert$conception_attempt[!fert$pregnant])))
})

test_that("simulate_fertility conception_attempt is 1-4 for pregnant cows", {
  if (any(fert$pregnant)) {
    attempts <- fert$conception_attempt[fert$pregnant]
    expect_true(all(attempts %in% 1:4))
  }
})

# ── simulate_activity ─────────────────────────────────────────────────────────
test_that("simulate_activity adds sensor columns", {
  expect_true(all(c("activity_score", "steps",
                    "lying_minutes", "standing_minutes") %in% names(act)))
})

test_that("lying + standing always equals 1440", {
  expect_true(all(act$lying_minutes + act$standing_minutes == 1440L))
})

test_that("simulate_activity values are in valid ranges", {
  expect_true(all(act$activity_score >= 10))
  expect_true(all(act$steps >= 100))
  expect_true(all(act$lying_minutes >= 300 & act$lying_minutes <= 900))
})

# ── education_summary ─────────────────────────────────────────────────────────
test_that("education_summary returns a tibble for whole-herd", {
  s <- education_summary(milk)
  expect_s3_class(s, "tbl_df")
  expect_equal(nrow(s), 1)
  expect_true("n_cows" %in% names(s))
  expect_true("mean_milk_kg" %in% names(s))
})

test_that("education_summary groups by breed correctly", {
  s <- education_summary(milk, by = "breed")
  expect_s3_class(s, "tbl_df")
  expect_true("breed" %in% names(s))
  expect_lte(nrow(s), 4)
})

test_that("education_summary groups by lactation correctly", {
  s <- education_summary(milk, by = "lactation")
  expect_true("lactation" %in% names(s))
  expect_true(all(s$n_cows > 0))
})

test_that("education_summary errors on unknown grouping column", {
  expect_error(education_summary(milk, by = "nonexistent_col"))
})

test_that("education_summary includes fertility columns when present", {
  s <- education_summary(fert)
  expect_true("conception_rate" %in% names(s))
  expect_true("mean_days_open" %in% names(s))
})

test_that("education_summary includes mastitis prevalence when present", {
  s <- education_summary(mast)
  expect_true("mastitis_prev" %in% names(s))
})
