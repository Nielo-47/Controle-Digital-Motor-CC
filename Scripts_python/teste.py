# Simulação do motor submetido a entradas na forma degrau, PRAS e PRBS com
# estimação dos parâmetros usando mínimos quadrados

from math import pi, prod
from numpy import array, identity, arange, transpose, vstack, empty, polyfit
from numpy.linalg import pinv, inv
from random import random, randrange, choice
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.pyplot as plt


def calcularMinimosQuadrados(entrada: list, saida: list):
    X, Y = [], []
    X, Y = empty((1, 4)), empty((1, 1))

    for k in range(len(saida) - 2):
        # Y.append([saida[k + 2]])
        # X.append([-saida[k + 1], -saida[k], entrada[k], entrada[k + 1]])
        Y = vstack([Y, [saida[k + 2]]])
        X = vstack([X, [-saida[k + 1], -saida[k], entrada[k], entrada[k + 1]]])

    # X, Y = array(X), array(Y)
    theta = pinv(X).dot(Y)
    aproximacao = X.dot(theta)

    return aproximacao, theta


f = open("prbs.txt", "r")
ent = [float(i) for i in f.read().split(",")]
f.close()

f = open("saida.txt", "r")
sai = [float(i) for i in f.read().split(",")]
f.close()

_, theta = calcularMinimosQuadrados(ent, sai)

print(theta)


nstep = 300

# random signal generation

a_range = [0, 2]
a = (
    np.random.rand(nstep) * (a_range[1] - a_range[0]) + a_range[0]
)  # range for amplitude

b_range = [2, 10]
b = (
    np.random.rand(nstep) * (b_range[1] - b_range[0]) + b_range[0]
)  # range for frequency
b = np.round(b)
b = b.astype(int)

b[0] = 0

for i in range(1, np.size(b)):
    b[i] = b[i - 1] + b[i]

# PRBS
a = np.zeros(nstep)
j = 0
while j < nstep:
    a[j] = 5
    a[j + 1] = -5
    j = j + 2

i = 0
prbs = np.zeros(nstep)
while b[i] < np.size(prbs):
    k = b[i]
    prbs[k:] = a[i]
    i = i + 1

prbs = [i * 400]

plt.plot(prbs, drawstyle="steps", label="PRBS")
plt.legend()
plt.show()
