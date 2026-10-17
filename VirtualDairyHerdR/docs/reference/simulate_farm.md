# Simulate a Farm Configuration

Creates a farm-level configuration object that defines the context for
all downstream simulations. Acts as the entry point for the
VirtualDairyHerdR simulation pipeline.

## Usage

``` r
simulate_farm(
  name = "Virtual Farm",
  location = "Ireland",
  system = c("grass-based", "housed", "mixed"),
  n_cows = 100,
  seed = NULL
)
```

## Arguments

- name:

  Character. Farm name. Default is `"Virtual Farm"`.

- location:

  Character. Country or region. Default is `"Ireland"`.

- system:

  Character. Production system: `"grass-based"`, `"housed"`, or
  `"mixed"`. Default is `"grass-based"`.

- n_cows:

  Integer. Target herd size. Default is 100.

- seed:

  Integer. Random seed for reproducibility. Default is NULL.

## Value

A named list with farm configuration parameters and metadata.

## Examples

``` r
farm <- simulate_farm(name = "Greenfield Farm", n_cows = 200, seed = 42)
```
