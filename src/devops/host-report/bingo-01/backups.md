# Plano Consolidado de Implantação de Backup — Host `bingo-01`

## Objetivos

Implementar um sistema de backup:

* simples
* auditável
* incremental
* restaurável manualmente
* resiliente
* de baixo overhead
* adequado para datasets científicos e desenvolvimento

O sistema deverá:

* preservar código e dados científicos relevantes
* evitar backup de lixo, caches e artefatos reconstruíveis
* permitir recuperação rápida local
* manter retenção histórica mensal
* minimizar impacto em I/O e CPU
* integrar-se naturalmente ao ecossistema Linux/systemd já utilizado no host

---

# Estratégia Geral

O sistema será dividido em três camadas.

| Camada             | Objetivo                      | Tecnologia        |
| ------------------ | ----------------------------- | ----------------- |
| Snapshot local     | Recuperação rápida            | rsync + hardlinks |
| Retenção histórica | Versionamento mensal          | Duplicati         |
| Auditoria          | Integridade e rastreabilidade | manifests + logs  |

---

# Arquitetura Geral

## Estrutura principal

```text
/backup-system/
├── config/
├── excludes/
├── logs/
├── manifests/
├── scripts/
├── tmp/
└── restore/
```

---

# Estrutura dos Backups

```text
/backup/
└── bingo-01/
    ├── home/
    │   └── USER/
    │       ├── current
    │       ├── 2026-05-01
    │       ├── 2026-05-08
    │       └── monthly/
    │
    ├── share/
    │   └── code/
    │
    ├── data/
    │
    └── jupyterhub/
        └── home/
```

---

# Política de Backup

# 1. Backup de `/home/$USER`

## Critérios

Aplicável apenas a usuários:

* pertencentes ao grupo `bingopb`
* com login válido

---

## Exclusões padrão

Não incluir:

```text
.*
.cache/
.local/share/Trash/
Downloads/
node_modules/
.venv/
__pycache__/
```

---

## Exclusões customizadas por usuário

Cada usuário poderá criar:

```text
~/.config/no-backups
```

Formato:

```text
Downloads/
large-dataset/
*.fits
```

O conteúdo será automaticamente incluído em:

```bash
--exclude-from
```

---

## Restrições importantes

* NÃO seguir links simbólicos
* NÃO sair do filesystem local do usuário
* NÃO copiar mounts externos

Parâmetros:

```bash
--one-file-system
```

Sem:

```bash
-L
```

---

## Estratégia local

### Frequência

* semanal
* incremental

### Tecnologia

* rsync
* snapshots hardlinked

### Destino

```text
/backup/bingo-01/home/$USER/
```

---

## Estratégia mensal

### Frequência

* mensal

### Tecnologia

* Duplicati
* compressão tgz
* versionado

### Retenção

```text
hold = 3
```

---

# 2. Backup de `/share/code/`

## Objetivo

Preservar:

* código-fonte
* notebooks
* scripts científicos
* pipelines
* documentação

---

## Exclusões padrão

```text
.*
.git/
node_modules/
__pycache__/
.venv/
dist/
build/
```

---

## Exclusão automática de projetos

Qualquer diretório contendo:

```text
.no-backup
```

será automaticamente excluído.

---

## Restrições

* não seguir links
* não cruzar filesystems

---

## Estratégia local

### Frequência

* semanal
* incremental

### Tecnologia

* rsync
* hardlinks

### Destino

```text
/backup/bingo-01/share/code/
```

---

## Estratégia mensal

### Frequência

* mensal

### Tecnologia

* Duplicati
* tgz
* versionado

### Retenção

```text
hold = 3
```

---

# 3. Backup de `/data/`

## Objetivo

Preservar:

* datasets científicos
* produtos processados
* arquivos FITS
* cubes
* pipelines intermediários

---

## Estratégia recomendada

### Dados ativos

* rsync incremental

### Dados frios/opcionais

* tgz
* arquivamento opcional

---

## Restrições

* não seguir links
* não cruzar filesystems

---

## Estratégia local

### Frequência

* semanal

### Tecnologia

* rsync incremental
* opcionalmente tgz para datasets frios

### Destino

```text
/backup/bingo-01/data/
```

---

## Estratégia mensal

### Frequência

* mensal

### Tecnologia

* Duplicati
* tgz
* versionado

### Retenção

```text
hold = 3
```

---

# 4. Backup de `/jupyterhub/home/*`

## Objetivo

Preservar:

* notebooks
* kernels customizados
* scripts interativos
* ambientes de trabalho de usuários

---

## Exclusões padrão

```text
.*
.ipynb_checkpoints/
.cache/
.local/share/jupyter/runtime/
```

---

## Restrições

* não seguir links
* não cruzar filesystems

---

## Estratégia local

### Frequência

* semanal
* incremental

### Tecnologia

* rsync
* hardlinks

### Destino

```text
/backup/bingo-01/jupyterhub/home/
```

---

## Estratégia mensal

### Frequência

* mensal

### Tecnologia

* Duplicati
* tgz
* versionado

### Retenção

```text
hold = 3
```

---

# Estratégia de Snapshots Incrementais

## Método

Utilizar:

```bash
rsync --link-dest
```

Benefícios:

* snapshots aparentam completos
* apenas diferenças ocupam espaço
* restauração simples
* baixo overhead
* excelente eficiência em datasets científicos

---

# Política de Retenção

## Snapshots locais

| Tipo     | Quantidade |
| -------- | ---------: |
| Semanais |          8 |
| Mensais  |          3 |

---

## Backups Duplicati

| Tipo    | Quantidade |
| ------- | ---------: |
| Mensais |          3 |

---

# Automação

# Scheduler

Utilizar:

* systemd services
* systemd timers

Não utilizar cron.

---

## Estrutura sugerida

```text
/etc/systemd/system/
├── backup-home.service
├── backup-home.timer
├── backup-share-code.service
├── backup-share-code.timer
├── backup-data.service
├── backup-data.timer
├── backup-jupyterhub.service
└── backup-jupyterhub.timer
```

## Implementação local já criada

As units foram adicionadas ao workspace em `bingo-01/systemd/` e um instalador opcional foi criado em `bingo-01/scripts/install-systemd-backup-units.sh`.

O instalador copia as units para `/etc/systemd/system/`, executa `daemon-reload` e habilita os quatro timers semanais.

---

# Logs e Auditoria

## Logs

Cada execução deverá gerar:

```text
/backup-system/logs/
```

com:

* timestamp
* duração
* quantidade de arquivos
* tamanho total
* erros
* exclusões aplicadas

---

## Manifests

Gerar:

```text
sha256sum
```

para:

* arquivos críticos
* scripts
* manifests de datasets

---

# Estratégia de Segurança

## Nunca incluir

```text
.cache
Trash
Downloads
node_modules
.venv
__pycache__
containers efêmeros
```

---

# Estratégia de Restauração

## Restauração rápida

Via:

```bash
rsync
cp
```

Diretamente dos snapshots locais.

---

## Restauração histórica

Via:

* Duplicati
* snapshots mensais

---

# Estratégia Operacional Recomendada

# Ordem de implementação

## Fase 1

Implementar:

* estrutura de diretórios
* scripts rsync
* snapshots incrementais
* retenção local

---

## Fase 2

Implementar:

* systemd timers
* logs
* manifests
* relatórios

---

## Fase 3

Implementar:

* Duplicati
* retenção mensal
* compactação
* verificação de integridade

---

## Fase 4

Implementar:

* testes completos de restauração
* auditoria
* documentação operacional

---

# Objetivo Final

Construir um sistema de backup:

* previsível
* restaurável
* incremental
* eficiente para datasets científicos
* amigável para código-fonte
* adequado para workflows GNU Radio/JupyterHub
* auditável
* simples de manter
* resiliente a erro humano

---

# Implementação local realizada

## Artefatos criados no workspace

* `backup-system/scripts/backup-common.sh` — funções comuns, logging e helpers de snapshots.
* `backup-system/excludes/*.default` — listas padrão de exclusão para cada escopo.
* `scripts/backup-home.sh` — snapshot incremental de `/home/$USER` para usuários do grupo `bingopb`.
* `scripts/backup-share-code.sh` — snapshot incremental de `/share/code` com exclusões automáticas por `.no-backup`.
* `scripts/backup-data.sh` — snapshot incremental de `/data` com exclusões básicas e `lost+found/`.
* `scripts/backup-jupyterhub.sh` — snapshot incremental de `/jupyterhub/home/*`.
* `scripts/generate-manifests.sh` — geração de manifests SHA-256 para scripts e exclusões.
* `scripts/backup-all-dry-run.sh` — execução de validação em modo dry-run.
* `scripts/backup-report.sh` — relatório operacional dos snapshots, logs e manifests.
* `scripts/backup-all.sh` — wrapper para executar toda a suíte de backup local.
* `scripts/backup-duplicati-monthly.sh` — backup mensal histórico via Duplicati (container Docker) com retenção `1M:3`.
* `systemd/backup-duplicati-monthly.service` e `systemd/backup-duplicati-monthly.timer` — automação mensal da camada histórica.
* `.env` — configuração local da passphrase do Duplicati (`DUPLICATI_ENCRYPTION_PASSPHRASE`).

## Como validar

Executar o wrapper de dry-run no diretório `bingo-01/`.

Também é possível gerar um relatório operacional com `scripts/backup-report.sh` e executar toda a suíte com `scripts/backup-all.sh`.

Para a camada mensal Duplicati, configurar a passphrase em `.env` e usar o script `scripts/backup-duplicati-monthly.sh`.

## Observação

O dry-run foi ajustado para funcionar no workspace sem exigir escrita em `/backup-system` ou `/backup` durante a validação.
