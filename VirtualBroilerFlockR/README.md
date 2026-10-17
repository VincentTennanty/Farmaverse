# VirtualBroilerFlockR

> Simulate biologically realistic synthetic broiler flock datasets for education,
> research, and precision livestock farming.

Part of the [**Farmaverse**](https://github.com/VincentTennanty/Farmaverse) —
an open ecosystem of R livestock simulation packages inspired by the
[pharmaverse](https://pharmaverse.org/).

---

## Status: 🔜 Planned

This package is not yet implemented. The folder is a placeholder while the
biological models and simulation logic are being designed.

If you have domain expertise in broiler production and want to help build
this package, **we would love to hear from you** — see [Contributing](#contributing) below.

---

## Planned scope

VirtualBroilerFlockR will generate synthetic, farm-ready broiler flock datasets
covering the full grow-out cycle from placement to slaughter.

### Simulation functions (proposed)

| Function | Description |
|---|---|
| `simulate_broiler_farm()` | Farm config — house size, stocking density, ventilation system, strain |
| `simulate_flock_placement()` | Placement records — chick number, placement weight, source hatchery |
| `simulate_liveweight()` | Daily liveweight curves by strain and sex using Gompertz growth model |
| `simulate_fcr()` | Feed intake and feed conversion ratio across the grow-out period |
| `simulate_mortality()` | Mortality patterns — early chick mortality, mid-cycle, pre-slaughter condemnations |
| `simulate_flock_uniformity()` | Coefficient of variation in liveweight; flock grading at slaughter |

### Key biological features needed

- Daily liveweight growth curves by commercial strain (Ross 308, Cobb 500) and sex
- Feed conversion ratio simulation with realistic day-to-day variation
- Mortality patterns: 7-day mortality spike, chronic low-level losses, heat stress events
- Flock uniformity: CV of liveweight at slaughter, impact on grading
- Welfare indicators: gait scoring, hock burn, pododermatitis prevalence
- Breed/strain coverage: Ross 308, Cobb 500, Hubbard, slower-growing welfare strains

---

## Contributing

This package needs people who understand broiler production systems and flock
performance. You do not need to be an R expert — if you can describe the biology
and provide realistic parameter ranges, we can help with the code.

**To get involved:**

1. Open an issue on [GitHub](https://github.com/VincentTennanty/Farmaverse/issues)
   describing the model or feature you want to contribute
2. Fork the repo and create a branch: `git checkout -b feature/broiler-growth`
3. Follow the VirtualDairyHerdR function style — roxygen2 docs, `seed` argument,
   returns a tibble with `synthetic_data = TRUE`
4. Submit a pull request

We are particularly looking for:
- Poultry researchers or PhD students working on growth or welfare models
- Broiler production managers or vets with flock performance benchmarks
- Data scientists with experience in poultry recording systems (APHIS, Aviagen performance objectives)

---

## License

MIT © Vincent Tennanty
