# CRAN Submission Comments — VirtualDairyHerdR 0.1.0

## Test environments

* Local: Windows 11, R 4.3.x
* R-hub: Windows Server 2022, R-devel
* R-hub: Ubuntu 22.04 LTS, R-release
* R-hub: macOS Ventura, R-release
* win-builder: R-devel

## R CMD CHECK results

0 errors | 0 warnings | 1 note

The one note:

    checking for future file timestamps ... NOTE
    unable to verify current time

This is a network-level clock verification issue on the local test machine
and is not related to the package. It does not appear on R-hub or win-builder.

## Downstream dependencies

None. This is a new package with no reverse dependencies.

## Notes for CRAN reviewers

* All simulation functions accept a `seed` argument for full reproducibility.
* All outputs carry `synthetic_data = TRUE` to clearly flag synthetic data.
* The `data-raw/` directory contains the script used to generate the two
  bundled datasets (`demo_herd`, `demo_mastitis`). It is excluded from the
  built package via `.Rbuildignore`.
* `LICENSE.md` is included for GitHub display only and is excluded from the
  built package via `.Rbuildignore`.
* This package is part of the Farmaverse ecosystem
  (<https://github.com/VincentTennanty/Farmaverse>), an open collection of
  R packages for simulating livestock datasets, inspired by the pharmaverse.
