### Requisitos de Desempenho RF – VSWR

**Frequência de projeto:** 1420,4 MHz  
**Modo dominante:** TE₁₀  
**Polarização:** Linear  

#### 1. Alvo de VSWR

- **VSWR típico esperado:** ≤ **1,15**
- **VSWR máximo aceitável:** **1,20**
- **Frequência de verificação:** 1420,4 MHz ± 5 MHz

#### 2. Condições de Medida

- Medição realizada em **VNA calibrado** (SOLT ou TRL)
- Plano de referência no **plano do flange do guia**
- Corneta em espaço aberto ou câmara anecoica
- Sem absorvedor dentro da corneta

#### 3. Critérios de Aceitação

A corneta será considerada **aceita** se:

- VSWR ≤ **1,20** na frequência central
- VSWR ≤ **1,30** em toda a faixa ±5 MHz
- Curva de VSWR sem ressonâncias abruptas (> 0,05 em 1 MHz)

#### 4. Requisitos Geométricos Críticos (relacionados ao VSWR)

- Garganta do guia:
  - a₀ = 220 mm ± 0,5 mm
  - b₀ = 140 mm ± 0,5 mm
- Planicidade do flange: ≤ 0,3 mm
- Ortogonalidade das paredes na garganta: ≤ 0,5°
- Degraus internos máximos: ≤ 0,5 mm

#### 5. Continuidade Elétrica

- Contato metálico direto em ≥ 80% das interfaces
- Uso obrigatório de:
  - Parafuso M4 cabeça panela
  - Arruela lisa + arruela de pressão
- Resistência DC entre painéis adjacentes: < 10 mΩ

#### 6. Não Conformidades

Podem causar reprovação por VSWR:

- Frestas internas > 1,0 mm
- Tinta ou anodização entre interfaces de contato
- Empeno do flange
- Desalinhamento do guia > 1,0 mm

#### 7. Observação

Pequenas variações na abertura da corneta afetam ganho e lóbulos,
mas **não** são determinantes para VSWR, desde que a garganta
e o flange atendam aos limites acima.


## Bill of Materials (BOM)

**Projeto:** Corneta Piramidal Ótima – Hidrogênio Neutro  
**Frequência:** 1420,4 MHz  
**Alvo RF:** VSWR ≤ 1,20 @ 1420,4 MHz  
**Espessura da chapa:** 1,0 mm  

---

### 1. Estrutura Metálica

| Item | Descrição | Material | Esp. | Qtde |
|---|---|---|---|---|
| 1 | Painel lateral H1 | Alumínio 5052-H32 | 1,0 mm | 1 |
| 2 | Painel lateral H2 | Alumínio 5052-H32 | 1,0 mm | 1 |
| 3 | Painel lateral E1 | Alumínio 5052-H32 | 1,0 mm | 1 |
| 4 | Painel lateral E2 | Alumínio 5052-H32 | 1,0 mm | 1 |
| 5 | Flange do guia retangular | Alumínio 6061-T6 | 3,0 mm | 1 |

**Observações:**

- Superfície interna **sem pintura**
- Rebarbas removidas
- Degraus internos ≤ 0,5 mm

---

### 2. Fixação Mecânica (Crítica para RF)

| Item | Especificação | Norma | Qtde |
|---|---|---|---|
| 6 | Parafuso M4 × 10 mm, cabeça panela | ISO 7045 | ~120 |
| 7 | Arruela lisa M4 | ISO 7089 | ~120 |
| 8 | Arruela de pressão M4 | DIN 127 | ~120 |
| 9 | Porca M4 | ISO 4032 | ~120 |

**Notas RF:**

- Uso obrigatório de **arruela lisa + pressão**
- Torque típico: **1,5–2,0 N·m**
- Garantir contato elétrico metálico

---

### 3. Interface RF

| Item | Descrição | Qtde |
|---|---|---|
| 10 | Guia de onda retangular (a₀ × b₀) | 1 |
| 11 | Junta metálica ou contato direto | — |

**Dimensões críticas:**

- a₀ = 220 ± 0,5 mm  
- b₀ = 140 ± 0,5 mm  
- Planicidade do flange ≤ 0,3 mm  

---

### 4. Elementos de Montagem

| Item | Descrição | Uso |
|---|---|---|
| 12 | Grampos temporários | Alinhamento |
| 13 | Calços metálicos finos | Ajuste fino |
| 14 | Escova / lixa fina | Limpeza de contato |

---

### 5. Ferramental Necessário (não consumível)

| Ferramenta | Observação |
|---|---|
| Serra circular | Corte linear |
| Dobradeira manual | Chapa 1 mm |
| Furadeira de bancada | Furos M4 |
| Broca Ø 4,5 mm | Fixação |
| Paquímetro | Controle crítico |
| Multímetro | Continuidade elétrica |
| VNA | Aceitação RF |

---

### 6. Controle de Qualidade

| Verificação | Critério |
|---|---|
| Continuidade elétrica | < 10 mΩ entre painéis |
| Planicidade do flange | ≤ 0,3 mm |
| VSWR @ 1420,4 MHz | ≤ 1,20 |
| VSWR ±5 MHz | ≤ 1,30 |

---

### 7. Observações Finais

- O desempenho de VSWR é dominado pela **garganta e flange**
- A abertura influencia ganho e lóbulos, não o casamento
- Precisão mecânica excessiva fora da garganta **não é necessária**


### Beam Pattern Esperado

**Frequência:** 1420,4 MHz  
**Comprimento de onda:** λ ≈ 211 mm  
**Tipo:** Corneta piramidal ótima  
**Polarização:** Linear  
**Modo dominante:** TE₁₀  

---

#### 1. Abertura Efetiva

- Abertura H (largura): a₁ = 676 mm ≈ 3,20 λ
- Abertura E (altura):  b₁ = 507 mm ≈ 2,40 λ
- Eficiência de abertura estimada: 55–65 %

---

#### 2. Ganho Esperado

| Parâmetro | Valor |
|---|---|
| Ganho típico | **15,5 – 16,5 dBi** |
| Ganho conservador | ≥ **15 dBi** |

> Nota: perdas dominadas por iluminação não uniforme e spillover, não por VSWR.

---

#### 3. Largura de Feixe (HPBW – Half Power Beamwidth)

Aproximação clássica para cornetas piramidais:

| Plano | HPBW típico |
|---|---|
| Plano H | **24° – 26°** |
| Plano E | **30° – 33°** |

- Feixe **elíptico**, como esperado
- Boa simetria devido a flare suave

---

#### 4. Lóbulos Laterais

| Parâmetro | Valor típico |
|---|---|
| 1º lóbulo lateral (H) | −22 a −25 dB |
| 1º lóbulo lateral (E) | −18 a −22 dB |
| Backlobe | < −30 dB |

> Lóbulos laterais são dominados pelo perfil de campo na abertura,
> não por pequenas imperfeições mecânicas.

---

#### 5. Relação com VSWR

- VSWR ≤ 1,20 **não afeta significativamente**:
  - ganho
  - HPBW
  - forma do feixe
- Ondulações no beam pattern **não correlacionam** com VSWR,
  mas sim com:
  - descontinuidades internas
  - degraus > 0,5 mm
  - frestas não condutivas

---

#### 6. Expectativa Experimental

Em campo aberto ou câmara:

- Feixe principal bem definido
- Excelente estabilidade de polarização
- Diferença entre simulação e medida:
  - ganho: ±0,5 dB
  - HPBW: ±2°

---

#### 7. Observação Final

Esta corneta é adequada para:

- radioastronomia (linha de 21 cm)
- medidas absolutas de potência
- calibração de sistemas de recepção

Sem necessidade de absorvedor ou choke adicional
para atingir os valores acima.


📐 Resumo das Dimensões Físicas – Corneta Piramidal (1420,4 MHz)
🔹 Parâmetros gerais

Frequência: 1420,4 MHz

Comprimento de onda: λ ≈ 211 mm

Espessura da chapa: 1,0 mm

Material: Alumínio 5052-H32 (paredes)

🔹 Guia de onda (garganta)
Parâmetro Símbolo Valor
Largura a₀ 220 mm ± 0,5 mm
Altura b₀ 140 mm ± 0,5 mm
Comprimento — 240 mm
Modo — TE₁₀
🔹 Corneta
Parâmetro Símbolo Valor
Abertura (H) a₁ 676 mm
Abertura (E) b₁ 507 mm
Comprimento axial L 610 mm
Ângulo de flare (H) θ_H 22,7°
Ângulo de flare (E) θ_E 18,2°
🔹 Desempenho esperado

Ganho: 15–16,5 dBi

HPBW:

H-plane: 24–26°

E-plane: 30–33°

VSWR alvo: ≤ 1,20
