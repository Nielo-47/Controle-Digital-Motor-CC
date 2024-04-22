# Simulação do motor submetido a entradas na forma degrau, PRAS e PRBS com
# estimação dos parâmetros usando mínimos quadrados

from math import pi
from numpy import array, identity, arange
from numpy.linalg import pinv
from random import random, choice
import matplotlib.pyplot as plt

# Definição dos parâmetros do motor
Pmec = 95 * 10**3
n = 0.913
Vn = 400
Wn = 1890 * pi / 30
Ra = 0.08
J = 0.56
La = 1.4 * 10**-3

Pele = Pmec / n
Cmn = Pmec / Wn
Ian = Pele / Vn
Kf = (Vn - Ian * Ra) / Wn
B = (Kf * Ian - Cmn) / Wn
Tm = J / B
Te = La / Ra
T = Te / 10

# Definição das matrizes A, B e C
A = array([[1 - T / Te, -Kf * T / La], [Kf * T / J, 1 - T / Tm]])

B = array([[T / La, 0], [0, -T / J]])

C = identity(2)  # Matriz identidade 2x2


def calcularSinaisDeSaida(entrada: list):
    # Definindo parâmetros da simulação
    x = array([[0], [0]])
    u = array([[Vn], [0]])
    W, Ia, t = [0], [0], [0]
    tempo = 0

    for i in range(len(entrada)):
        # Definindo a entrada de tensão do sistema conforme parâmetro
        u[0] = entrada[i]

        # Calculando as saídas e armazenando-as
        x = A.dot(x) + B.dot(u)

        Ia.append(x[0].item())
        W.append(x[1].item())

        # Incrementando e armazenando o tempo de simulação
        tempo += T
        t.append(tempo)

    return W, Ia, t


def calcularMinimosQuadrados(entrada: list, saida: list):
    X, Y = [], []

    for k in range(len(saida) - 2):
        Y.append([saida[k + 2]])
        X.append([-saida[k + 1], -saida[k], entrada[k], entrada[k + 1]])

    X, Y = array(X), array(Y)
    theta = pinv(X).dot(Y)
    aproximacao = X.dot(theta)

    return aproximacao, theta


def gerarSinaisDeEntrada():
    # Número de iterações (apróx 5 s)
    N = 2900

    # Gerando sinal de entrada degrau
    degrau = [Vn] * N

    # Gerando sinal de entrada PRAS
    pras = [Vn] * 500

    while len(pras) < N + 500:
        pras += [random() * Vn] * 150

    pras = pras[:N]

    # Gerando sinal de entrada PRBS
    prbs = [Vn] * 500

    while len(prbs) < N + 500:
        prbs += [Vn + choice([1, -1]) * 125] * round(100 * random())

    prbs = prbs[:N]

    return (degrau, pras, prbs)


# Realizando simulação
# Setup
entradas = gerarSinaisDeEntrada()
nomes = ["Degrau", "PRAS", "PRBS"]

# Calculando estimativa para sinais de velocidade
print("Coeficentes MQ para estimativa de velocidade")
for i, entrada in enumerate(entradas):
    W, _, t = calcularSinaisDeSaida(entrada)
    W_MQ, theta_W = calcularMinimosQuadrados(entrada, W)

    tempo = t[: len(W_MQ)]

    plt.figure(i, figsize=(10, 7))
    plt.plot(tempo, entrada[1:], color="g", linewidth=1)
    plt.plot(tempo, W[2:], color="r", linewidth=2)
    plt.plot(tempo, W_MQ, color="b", linewidth=1)
    plt.legend(["Tensão", "Saida do motor", "Estimativa mínimos quadrados"])
    plt.title(f"Velocidade do eixo\n({nomes[i]})")
    plt.xlabel("Tempo (s)")
    plt.ylabel("Velocidade (rad/s)")
    plt.yticks(arange(min(W), max(entrada), 20), fontsize=8)

    print(f"({nomes[i]})\n", theta_W, "\n")

plt.show()
plt.close()

# Calculando estimativa para sinais de corrente
print("Coeficentes MQ para estimativa de corrente")
for i, entrada in enumerate(entradas):
    _, Ia, t = calcularSinaisDeSaida(entrada)
    Ia_MQ, theta_Ia = calcularMinimosQuadrados(entrada, Ia)

    tempo = t[: len(Ia_MQ)]

    plt.figure(i, figsize=(10, 7))
    plt.plot(tempo, entrada[1:], color="g", linewidth=1)
    plt.plot(tempo, Ia[2:], color="r", linewidth=2)
    plt.plot(tempo, Ia_MQ, color="b", linewidth=1)
    plt.legend(["Tensão", "Saida do motor", "Estimativa mínimos quadrados"])
    plt.title(f"Corrente na armadura\n({nomes[i]})")
    plt.xlabel("Tempo (s)")
    plt.ylabel("Corrente (A)")
    plt.yticks(arange(min(Ia), max(Ia), 200), fontsize=8)

    print(f"({nomes[i]})\n", theta_Ia, "\n")

plt.show()
