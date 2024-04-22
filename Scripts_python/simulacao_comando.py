# Simulação Motor CC com variação de carga e variação paramétrica
from math import pi
from numpy import array, identity, arange
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

# Definindo parâmetros da simulação
x = array([[0], [0]])
u = array([[Vn], [0]])
W, Ia, t = [0], [0], [0]
tempo = 0
N = 2900  # Número de iterações (apróx 5 s)

for i in range(1, N):
    if i == 500:  # Adicionando carga nominal
        u.put(1, Cmn)

    elif i == 1500:  # Elevando resistência da armadura
        Ra = 0.5
        Te = La / Ra
        A = array([[1 - T / Te, -Kf * T / La], [Kf * T / J, 1 - T / Tm]])

    elif i == 2300:  # Removendo a carga
        u.put(1, 0)

    # Calculando as saídas e armazenando-as
    x = A.dot(x) + B.dot(u)

    Ia.append(x[0].item())
    W.append(x[1].item())

    # Incrementando e armazenando o tempo de simulação
    tempo += T
    t.append(tempo)


# Mostrando os gráficos de velocidade e corrente
vel = plt.figure(1)
plt.plot(t, W, color="r")
plt.title("Velocidade do eixo")
plt.xlabel("Tempo (s)")
plt.ylabel("Velocidade (rad/s)")
plt.yticks(arange(min(W), max(W) + 20, 15), fontsize=8)
plt.legend(["Velocidade"])

off = 5
plt.annotate(
    "Entrada de carga",
    xy=(T * 500, W[500] + off),
    xytext=(T * 500, W[500] + off * 6),
    horizontalalignment="center",
    fontsize=8,
    arrowprops=dict(facecolor="black", lw=1, arrowstyle="->"),
)

plt.annotate(
    "Elevando resistência\nda armadura",
    xy=(T * 1500, W[1500] + off),
    xytext=(T * 1500, W[1500] + off * 6),
    horizontalalignment="center",
    fontsize=8,
    arrowprops=dict(facecolor="black", lw=1, arrowstyle="->"),
)

plt.annotate(
    "Removendo a carga",
    xy=(T * 2300, W[2300] - off),
    xytext=(T * 2300, W[2300] - off * 6 - 5),
    horizontalalignment="center",
    fontsize=8,
    arrowprops=dict(facecolor="black", lw=1, arrowstyle="->"),
)


corrente = plt.figure(2)
plt.plot(t, Ia, color="b")
plt.title("Corrente na armadura")
plt.xlabel("Tempo (s)")
plt.ylabel("Corrente (A)")
plt.yticks(arange(-800, 2800, 200), fontsize=8)
plt.legend(["Corrente"])

off = 50

plt.annotate(
    "Entrada de carga",
    xy=(T * 500, Ia[500] - off),
    xytext=(T * 500, Ia[500] - off * 8),
    horizontalalignment="center",
    fontsize=8,
    arrowprops=dict(facecolor="black", lw=1, arrowstyle="->"),
)

plt.annotate(
    "Elevando resistência\nda armadura",
    xy=(T * 1500, Ia[2300] + off),
    xytext=(T * 1500, Ia[2300] + off * 8),
    horizontalalignment="center",
    fontsize=8,
    arrowprops=dict(facecolor="black", lw=1, arrowstyle="->"),
)

plt.annotate(
    "Removendo a carga",
    xy=(T * 2300, Ia[2300] + off),
    xytext=(T * 2300, Ia[2300] + off * 8),
    horizontalalignment="center",
    fontsize=8,
    arrowprops=dict(facecolor="black", lw=1, arrowstyle="->"),
)

plt.show()
