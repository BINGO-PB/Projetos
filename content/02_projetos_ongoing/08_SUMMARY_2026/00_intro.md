# Projetos 2026
## Reunião de Equipe BINGO-PB -- set/2026


## Qualidade de Código

### Ferramentas

- **Lint/format:** `ruff check .` and `ruff format --check .`
  (`pyproject.toml` → `[tool.ruff]`), including the `G` logging-format rules.
- **Types:** `mypy src` (strict).
- **Tests:** `pytest` (unit/integration/performance per
  `.promps/implementation_plan.md` §5).
- **Git hooks:** run `pre-commit install` once after cloning. Hooks
  (`.pre-commit-config.yaml`) run on every commit:
  - `ruff` (lint + format)
  - `mypy` (on `src/`)
  - `trailing-whitespace`, `end-of-file-fixer`, `check-yaml`,
    `check-added-large-files`, `detect-private-key`
  - `check-module-header` (local hook, §2 above)
- CI (`.github/workflows/ci.yml`) re-runs lint, type-check, and tests on
  every push/PR as a backstop for anyone who skips local hooks.

### Module docstring header

Every Python module starts with a docstring that states its own repo-relative
path (first line), a brief description, and the collaboration marker lines,
in this exact shape:

### Documentação

Documentação em Markdown, usando mkdocs ou myst

### TechStack

- numpy/scipy
- dask/xarray lazy
- httpx
- pydantic/sqlmodel
- configurações em toml
- machine message exchange em json
- persistência em postgresql
- Utilização de padrão de portas e adaptadores para garantir constratos estáveis.
- Empacotamento cvom pyproject.toml (backend uv)

```python
"""src/bingo_sdhdf/domain/schema_model.py

Pydantic meta-model describing the SDHDF v4.0 structural schema.

# BINGO Collaboration
# @BINGO-PB
"""
```

## Projetos de Software


:::{admonition} **RadioSkySimSuite**
:class: important dropdown

:::


:::{admonition} **GNSSTools4Astro**
:class: important dropdown

:::


:::{admonition} **BingoSDHDF**
:class: important dropdown

:::


:::{admonition} **Minicorneta**
:class: important dropdown

### Próximas etapas
- [ ] Caracterização de Hardware
- [ ] Simulação do Feixe
- [ ] Empacotamento RTLSDR Controller
- [ ] **new feature** USRP Controller
- [ ] Empacotamento GnuradioProcessor
- [ ] Congelamento de contratos para aplicação downstream
- [ ] Estabilização WaterfallProcessor

### Medidas
- Antena Uirapuru
    - Receptores Rec_H e Rec_V
    - Rotina:
        - Aquecimento: 10´
        - **cold** load Rec_H: 10'
        - **hot** load Rec_H: 10'
        - **cold** load Rec_V: 10'
        - **hot** load Rec_V: 10'
        - **sky** Rec_H: 30'
        - **sky** Rev_V: 30´
- Repetir procedimento com USRP
- Repetir procedimento com minicorneta
:::


:::{admonition} **RadioHorn**
:class: important dropdown

:::

:::{admonition} **UirapuruTelescope**
:class: important dropdown

### Próximas Etapas
- [ ] Produzir bitstream com 4086 canais e canal de controle com interface de 1GBe
- [ ] Estabilização de scripts de controlle e contratos.

### Medidas
- [ ] definir ganhos do ADC
- cadência de 0.5´´
- **cold** load Rec_H/Rec_V: 30'
- **hot** load Rec_H/Rec_V: 30'
- **sky** Rec_H/Rec_V: 24 h
:::

:::{admonition} **ArduinoSensors**
:class: important dropdown

### Próximas Etapas
- [ ] Integração de Hardware
- [ ] Código Embarcado
- [ ] Serviço
- [ ] Persistência

:::


:::{admonition} **pyCallistoSpectrometer**
:class: important dropdown

### Próximas Etapas
- [ ] COnsolidação de Firmware
- [ ] Programção Arduino
- [ ] Teste de pinagem em console serial
- [ ] Integração da aplicação

:::

:::{admonition} **bingoSDHDF**
:class: important dropdown

### Próximas Etapas
- [ ] Testes Unitários
- [ ] Estabilização de Esquema
- [ ] Persistência
- [ ] Benchmark

:::
