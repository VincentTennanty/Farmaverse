# VirtualSheepFlockR

> Simulate biologically realistic synthetic sheep flock datasets for education,
> research, and precision livestock farming.

Part of the [**Farmaverse**](https://github.com/VincentTennanty/Farmaverse) —
an open ecosystem of R livestock simulation packages inspired by the
[pharmaverse](https://pharmaverse.org/).

---

## Status: 🔜 Planned

This package is not yet implemented. The folder is a placeholder while the
biological models and simulation logic are being designed.

If you have domain expertise in sheep production and want to help build
this package, **we would love to hear from you** — see [Contributing](#contributing) below.

---

## Planned scope

VirtualSheepFlockR will generate synthetic, farm-ready sheep flock datasets
covering the full production year from tupping through to weaning.

### Simulation functions (proposed)

| Function | Description |
|---|---|
| `simulate_sheep_farm()` | Farm config — system (lowland, upland, hill), breed, lambing pattern |
| `simulate_flock()` | Ewe-level attributes — breed, age, parity, body condition score |
| `simulate_lambing()` | Lambing records — litter size, lamb birth weight, lamb survival, foster events |
| `simulate_bcs()` | Body condition score trajectory across the production year |
| `simulate_parasite_burden()` | Nematode burden — FEC, FAMACHA score, anthelmintic treatment records |
| `simulate_flock_kpis()` | Flock-level KPIs — scanning %, lambing %, weaning %, mortality % |

### Key biological features needed

- Litter size distributions by breed and parity (singles, twins, triplets)
- Lamb survival curves — early neonatal mortality, exposure, mismothering
- BCS trajectories: pre-tupping, mid-pregnancy, pre-lambing, weaning targets
- Nematode burden models: periparturient rise, seasonal patterns, FEC distributions
- Breed coverage: Suffolk, Texel, Charollais, Mule, Blackface, Cheviot

---

## Contributing

This package needs people who understand sheep production systems and flock
health. You do not need to be an R expert — if you can describe the biology
and provide realistic parameter ranges, we can help with the code.

**To get involved:**

1. Open an issue on [GitHub](https://github.com/VincentTennanty/Farmaverse/issues)
   describing the model or feature you want to contribute
2. Fork the repo and create a branch: `git checkout -b feature/sheep-lambing`
3. Follow the VirtualDairyHerdR function style — roxygen2 docs, `seed` argument,
   returns a tibble with `synthetic_data = TRUE`
4. Submit a pull request

We are particularly looking for:
- Sheep researchers or PhD students working on reproductive or parasite models
- Flock health vets or consultants with lambing performance benchmarks
- Data scientists with experience in sheep recording systems (Signet, Sheep Ireland)

---

## License

MIT © Vincent Tennanty
