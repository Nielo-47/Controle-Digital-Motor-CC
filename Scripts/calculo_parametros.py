from math import pi

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


def mostrarValores():
    print("Pele = ", Pele)
    print("Cmn = ", Cmn)
    print("Ian = ", Ian)
    print("Kfluxo = ", Kf)
    print("B = ", B)
    print("Te = ", Te)
    print("Tm = ", Tm)


mostrarValores()

# Estado permanente da velocidade e da corrente na armadura

# Degrau
W_ss = (Kf / (Ra * B)) / (Kf**2 / (Ra * B)) * Vn
Ia_ss = (B/J)/La / (Kf**2 / (La * J)) * Vn

# Rampa e Parabola tendem a infinito

print(
    f"\nVelocidade no estado permanente com aplicação de degrau, tensão nominal e a vazio\n{W_ss} rad/s"
)
print(
    f"\nCorrente na armadura no estado permanente com aplicação de degrau, tensão nominal e a vazio\n{Ia_ss} A"
)


