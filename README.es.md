# FuzzyCountries

[English](README.md) | **Español**

Modelo socioeconómico difuso para 49 países, desarrollado originalmente como
TFG con **Ciao Prolog + RFuzzy**. El repositorio incluye además un paquete
Python que reproduce el modelo, tests automáticos, auditoría de datos, CI y una
exportación lista para Power BI.

## Qué contiene

- `code.pl`: modelo original en Ciao Prolog/RFuzzy (fuente de verdad).
- `src/fuzzy_countries/`: implementación de referencia en Python. Lee el mismo
  `code.pl`, evalúa funciones de pertenencia lineales a trozos y reglas con
  media aritmética y `fnot(x) = 1 - x`.
- `tests/`: 37 tests (parser, interpolación, rankings publicados, limpieza de
  datos, auditoría, export, CLI y credibilidad).
- `docs/`: diccionario de datos, modelo completo, calidad de datos y guía de
  Power BI.
- `exports/`: estrella de tablas CSV generada por el CLI (no versionada).

## Inicio rápido

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS / Linux
source .venv/bin/activate

pip install -e ".[dev]"

fuzzy-countries summary
fuzzy-countries validate
fuzzy-countries rank clean_country --top 10
fuzzy-countries audit
fuzzy-countries export --out exports
pytest
```

## Resultados principales

| Regla | Primeros países |
| --- | --- |
| `clean_country` | Islandia 0.906 · Noruega 0.805 · Dinamarca 0.792 |
| `developed_country` | Japón 0.889 · Alemania 0.855 · Francia 0.832 · España 7.ª (0.796) |
| `economically_stable_country` | Tailandia 0.722 · Japón 0.702 · Alemania 0.647 |
| `quality_healthcare_country` | Japón 0.916 · Islandia 0.914 · Finlandia 0.910 · España 7.ª (0.897) |

## Documentación

- [Modelo y reglas](docs/model.md)
- [Diccionario de datos](docs/data_dictionary.md)
- [Calidad de datos](docs/data_quality.md)
- [Guía de Power BI](docs/powerbi.md)

## Aviso sobre los datos

El motor Python usa los valores de `code.pl` tal cual, porque son los que
generaron los resultados publicados. La auditoría detecta 8 inconsistencias
(por ejemplo, el signo de la temperatura de Canadá, el desempleo y las
renovables de Argelia, o la edad mediana de Luxemburgo). No se corrigen de
forma silenciosa: están documentadas en [docs/data_quality.md](docs/data_quality.md).

## Licencia

Código y documentación: [MIT](LICENSE). Los datasets de terceros conservan sus
términos originales.
