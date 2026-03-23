# Controle Digital de Motor CC

Projeto de modelagem, identificação e controle digital de um motor de corrente contínua (CC) de 95 kW, desenvolvido como trabalho acadêmico. O projeto contempla a obtenção do modelo matemático do motor, identificação de parâmetros via Mínimos Quadrados, projeto de controladores nos planos contínuo (s) e discreto (z), e simulações utilizando MATLAB/Simulink, Scilab/Xcos e Python.

Para ver os resultados das simulações e análise, acesse o [documento do trabalho.](https://docs.google.com/document/d/10vdmbsnsIYc34fiDCt3tkEhxyy3bf9GkYrQg-X2g6mA/edit?usp=sharing)

---

## Sumário

- [Visão Geral](#visão-geral)
- [Parâmetros do Motor](#parâmetros-do-motor)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Metodologia](#metodologia)
- [Ferramentas Utilizadas](#ferramentas-utilizadas)
- [Como Executar](#como-executar)
- [Datasheets](#datasheets)

---

## Visão Geral

O projeto aborda o controle digital de um motor CC de excitação separada com os seguintes objetivos:

1. **Modelagem matemática** do motor CC no espaço de estados e por funções de transferência;
2. **Discretização** do modelo contínuo com período de amostragem `T = Te/10`;
3. **Identificação de parâmetros** utilizando o método dos Mínimos Quadrados com sinais de excitação degrau, PRAS e PRBS;
4. **Projeto de controladores** PI/PID por lugar das raízes no plano z;
5. **Controle em cascata** (malha interna de corrente + malha externa de velocidade);
6. **Realimentação de estados** com projeto de observador de ordem reduzida;
7. **Simulações** com variação de carga e variação paramétrica.

---

## Parâmetros do Motor

| Parâmetro | Símbolo | Valor | Unidade |
|---|---|---|---|
| Potência mecânica nominal | Pₘₑ꜀ | 95.000 | W |
| Rendimento | η | 0,913 | — |
| Tensão nominal da armadura | Vₙ | 400 | V |
| Velocidade nominal | ωₙ | 1890 | rpm |
| Resistência da armadura | Rₐ | 0,08 | Ω |
| Indutância da armadura | Lₐ | 1,4 | mH |
| Momento de inércia | J | 0,56 | kg·m² |

**Parâmetros calculados:**

- **Kf** — Constante de força contra-eletromotriz / torque
- **B** — Coeficiente de atrito viscoso
- **Tₑ = Lₐ/Rₐ** — Constante de tempo elétrica
- **Tₘ = J/B** — Constante de tempo mecânica
- **T = Tₑ/10** — Período de amostragem

---

## Estrutura do Projeto

```
Controle-Digital-Motor-CC/
│
├── Frequência Contínua/          # Modelos e simulações no domínio contínuo (plano s)
│   ├── DB_MotorCC_Completo.zcos            # Modelo completo do motor (Scilab/Xcos)
│   ├── MotorCC_Cl_W_s.zcos                 # Malha fechada de velocidade
│   ├── MotorCC_Ia_Cl_s.zcos                # Malha fechada de corrente
│   ├── MotorCC_W_Va_com_tomada_intermediaria_Ia_s.zcos  # Controle em cascata
│   └── Servosistema_integrador_realimentacao.zcos
│
├── Frequência Discreta/          # Modelos e simulações no domínio discreto (plano z)
│   ├── MotorCC_Completo_z.zcos             # Modelo discreto completo (Scilab/Xcos)
│   ├── MotorCC_W_Cl_z.zcos                 # Malha fechada de velocidade discreta
│   ├── MotorCC_Ia_Cl_z.zcos                # Malha fechada de corrente discreta
│   ├── Modelo_Motor_Minimos_Quadrados.slx  # Identificação por MQ (Simulink)
│   ├── Planta_completa_controle_de_corrente.slx
│   ├── Planta_completa_controle_velocidade.slx
│   ├── Planta_completa_controle_velocidade_corrente.slx
│   └── Servosistema_integrador_realimentacao.slx
│
├── Scripts/                      # Scripts MATLAB e Scilab
│   ├── parametros_do_motor.m               # Cálculo dos parâmetros do motor
│   ├── lugar_das_raizes_matlab.m           # Lugar das raízes e funções de transferência
│   ├── projeto_controlador_w.m             # Projeto do controlador de velocidade (RL)
│   ├── projeto_controlador_velocidade.m    # Controlador de velocidade em cascata
│   ├── realimentacao_de_estados.m          # Projeto por realimentação de estados
│   ├── minimos_quadrados_matlab.m          # Identificação por Mínimos Quadrados
│   ├── simulacao.sci                       # Simulação com variação de carga (Scilab)
│   ├── w_com_corrente_mq.sci               # Estimação via MQ com entrada PRBS (Scilab)
│   ├── lugar_das_raizes.sce                # Lugar das raízes (Scilab)
│   ├── minimos_quadrados.sce               # Mínimos quadrados (Scilab)
│   ├── calculo_parametros.py               # Cálculo dos parâmetros do motor (Python)
│   └── Comparacao_continuo_discreto.slx    # Comparação contínuo vs. discreto (Simulink)
│
├── Scripts_python/               # Scripts Python para simulação e identificação
│   ├── simulacao_comando.py                # Simulação com variação de carga e paramétrica
│   └── minimos_quadrados.py                # Identificação por Mínimos Quadrados
│
├── Datasheets/                   # Datasheets dos componentes utilizados
│   ├── Baumer_GT-5_EN_20210430_DS1.pdf     # Encoder incremental Baumer GT-5
│   ├── Data_Sheet_serie_77.pdf             # Amperímetro série 77
│   ├── NK_DLT_-_Manual.pdf                 # Tacôgerador NK DLT
│   └── WEG-ctw900-50036034-catalogo-portugues-br-dc.pdf  # Conversor de frequência WEG CTW900
│
├── prbs.txt                      # Sinal PRBS gerado para identificação
├── saida.txt                     # Saída do sistema para identificação
└── ControlSystemDesignerSession.mat        # Sessão salva do Control System Designer
```

---

## Metodologia

### 1. Modelagem do Motor CC

O motor CC de excitação separada é representado pelo modelo em espaço de estados:

```
x[k+1] = A·x[k] + B·u[k]
y[k]   = C·x[k]
```

onde o vetor de estados é `x = [Iₐ, ω]ᵀ` (corrente na armadura e velocidade angular), a entrada é a tensão de armadura `Vₐ` e a perturbação é o torque de carga `Cₘ`.

### 2. Identificação de Parâmetros (Mínimos Quadrados)

Os parâmetros das funções de transferência discretas são identificados a partir de sinais de entrada/saída utilizando o Método dos Mínimos Quadrados Recursivo (MQ). Três tipos de sinais de excitação são empregados:

- **Degrau** — para verificação do regime permanente;
- **PRAS** (Pseudo-Random Amplitude Signal) — variações de amplitude pseudo-aleatórias;
- **PRBS** (Pseudo-Random Binary Sequence) — sequência binária pseudo-aleatória, que oferece melhor excitação espectral para identificação.

### 3. Projeto dos Controladores

#### 3.1 Controlador PI/PID por Lugar das Raízes (plano z)

O controlador é projetado utilizando a ferramenta **Control System Designer** do MATLAB, com posicionamento de pólos de malha fechada no plano z a partir do lugar das raízes. São projetados:

- Controlador PI para a malha de corrente;
- Controlador PI/PID para a malha de velocidade;
- Controle em cascata (corrente + velocidade).

A cadeia de malha aberta discreta inclui os ganhos dos conversores ADC/DAC de 10 bits, do amperímetro, do tacôgerador e do condicionamento de sinal.

#### 3.2 Realimentação de Estados com Observador

O controlador por realimentação de estados é projetado com:

- **Alocação de pólos** do sistema em malha fechada em `z = 0,5` (raízes reais e iguais);
- **Observador de ordem reduzida** (observabilidade pelo estado de velocidade);
- **Ação integral** para rejeição de perturbações em regime permanente.

Os ganhos `K₁`, `K₂`, `Kᵢ` (realimentação de estados + integrador) e `Ko₁`, `Ko₂` (observador) são calculados analiticamente via resolução de sistemas lineares.

### 4. Simulações

As simulações avaliam o comportamento do motor sob:

- **Variação de carga**: aplicação e remoção do torque nominal `Cₘₙ`;
- **Variação paramétrica**: aumento da resistência de armadura `Rₐ` de 0,08 Ω para 0,5 Ω (simulando aquecimento);
- **Comparação contínuo × discreto**: verificação da equivalência entre os modelos.

---

## Ferramentas Utilizadas

| Ferramenta | Versão recomendada | Uso |
|---|---|---|
| [MATLAB](https://www.mathworks.com/products/matlab.html) | R2023b ou superior | Scripts `.m`, Control System Designer |
| [Simulink](https://www.mathworks.com/products/simulink.html) | R2023b ou superior | Modelos `.slx` |
| [Scilab](https://www.scilab.org/) | 6.x ou superior | Scripts `.sce/.sci` |
| [Xcos](https://www.scilab.org/software/xcos) | (incluso no Scilab) | Modelos `.zcos` |
| [Python](https://www.python.org/) | 3.8 ou superior | Simulação e identificação |
| NumPy | — | Álgebra linear |
| Matplotlib | — | Visualização dos resultados |

### Instalação das dependências Python

```bash
pip install numpy matplotlib
```

---

## Como Executar

### Scripts Python

```bash
# Simulação do motor com variação de carga e paramétrica
python Scripts_python/simulacao_comando.py

# Identificação de parâmetros por Mínimos Quadrados
python Scripts_python/minimos_quadrados.py
```

### Scripts MATLAB

Abra o MATLAB, navegue até a pasta `Scripts/` e execute:

```matlab
% Calcular parâmetros do motor
run('parametros_do_motor.m')

% Lugar das raízes e funções de transferência
run('lugar_das_raizes_matlab.m')

% Projeto do controlador de velocidade
run('projeto_controlador_w.m')

% Projeto por realimentação de estados
run('realimentacao_de_estados.m')

% Identificação por Mínimos Quadrados
run('minimos_quadrados_matlab.m')
```

### Scripts Scilab

Abra o Scilab, navegue até a pasta `Scripts/` e execute:

```scilab
// Simulação com variação de carga
exec('simulacao.sci')

// Identificação via Mínimos Quadrados com PRBS
exec('w_com_corrente_mq.sci')
```

Para abrir os diagramas de blocos, utilize o **Xcos** e abra os arquivos `.zcos` nas pastas `Frequência Contínua/` e `Frequência Discreta/`.

---

## Datasheets

Os datasheets dos componentes da bancada experimental estão na pasta `Datasheets/`:

- **Encoder incremental Baumer GT-5** — medição de posição/velocidade angular;
- **Amperímetro série 77** — medição de corrente na armadura;
- **Tacôgerador NK DLT** — sensor analógico de velocidade (ganho: 0,0033 V·s/rad);
- **Conversor WEG CTW900** — acionamento do motor CC por chopper.

---

## Referências

- OGATA, K. *Engenharia de Controle Moderno*. 5. ed. Pearson, 2010.
- FRANKLIN, G. F.; POWELL, J. D.; EMAMI-NAEINI, A. *Feedback Control of Dynamic Systems*. 8. ed. Pearson, 2019.
- AGUIRRE, L. A. *Introdução à Identificação de Sistemas*. 4. ed. UFMG, 2015.
