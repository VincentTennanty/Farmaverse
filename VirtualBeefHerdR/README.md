# VirtualBeefHerdR

> Simulate biologically realistic synthetic beef cattle datasets for education,
> research, and precision livestock farming.

Part of the [**Farmaverse**](https://github.com/VincentTennanty/Farmaverse) —
an open ecosystem of R livestock simulation packages inspired by the
[pharmaverse](https://pharmaverse.org/).

---

## Status: 🔜 Planned

This package is not yet implemented. The folder is a placeholder while the
biological models and simulation logic are being designed.

If you have domain expertise in beef cattle production and want to help build
this package, **we would love to hear from you** — see [Contributing](#contributing) below.

---

## Planned scope

VirtualBeefHerdR will generate synthetic, farm-ready beef cattle datasets
covering the full production cycle from weaning to finishing.

### Simulation functions (proposed)

| Function | Description |
|---|---|
| `simulate_beef_farm()` | Farm config — system (suckler, feedlot, grass-finishing), breed, target finishing weight |
| `simulate_beef_herd()` | Animal-level attributes — breed, sex, age, entry weight |
| `simulate_growth()` | Daily liveweight using Gompertz / Richards / Von Bertalanffy curves |
| `simulate_beef_health()` | Health events — BRD, lameness, liver fluke, treatment records |
| `simulate_finishing()` | Kill-out %, carcass weight, carcass grade, fat score |

### Key biological features needed

- Growth curve models (Gompertz, Richards, or Von Bertalanffy) by breed and sex
- Realistic weight gain trajectories with feed conversion efficiency
- Health event simulation: BRD incidence by season and age, lameness, liver fluke burden
- Finishing performance: kill-out %, carcass conformation grade (EUROP), fat score
- Breed coverage: Angus, Hereford, Charolais, Limousin, Simmental, Friesian bull

---

## Contributing

This package needs people who understand beef cattle biology and production
systems. You do not need to be an R expert — if you can describe the biology
and provide realistic parameter ranges, we can help with the code.

**To get involved:**

1. Open an issue on [GitHub](https://github.com/VincentTennanty/Farmaverse/issues)
   describing the model or feature you want to contribute
2. Fork the repo and create a branch: `git checkout -b feature/beef-growth-curve`
3. Follow the VirtualDairyHerdR function style — roxygen2 docs, `seed` argument,
   returns a tibble with `synthetic_data = TRUE`
4. Submit a pull request

We are particularly looking for:
- Researchers or PhD students working on beef growth modelling
- Farm consultants or vets with finishing performance benchmarks
- Data scientists with experience in beef production datasets

---

## License

MIT © Vincent Tennanty
