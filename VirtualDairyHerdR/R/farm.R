#' Simulate a Farm Configuration
#'
#' Creates a farm-level configuration object that defines the context for all
#' downstream simulations. Acts as the entry point for the VirtualDairyHerdR
#' simulation pipeline.
#'
#' @param name Character. Farm name. Default is `"Virtual Farm"`.
#' @param location Character. Country or region. Default is `"Ireland"`.
#' @param system Character. Production system: `"grass-based"`, `"housed"`,
#'   or `"mixed"`. Default is `"grass-based"`.
#' @param n_cows Integer. Target herd size. Default is 100.
#' @param seed Integer. Random seed for reproducibility. Default is NULL.
#'
#' @return A named list with farm configuration parameters and metadata.
#'
#' @examples
#' farm <- simulate_farm(name = "Greenfield Farm", n_cows = 200, seed = 42)
#'
#' @export
simulate_farm <- function(name     = "Virtual Farm",
                          location = "Ireland",
                          system   = c("grass-based", "housed", "mixed"),
                          n_cows   = 100,
                          seed     = NULL) {
  system <- match.arg(system)
  if (!is.null(seed)) set.seed(seed)

  list(
    name          = name,
    location      = location,
    system        = system,
    n_cows        = n_cows,
    seed          = seed,
    synthetic_data = TRUE,
    source        = "VirtualDairyHerdR"
  )
}
