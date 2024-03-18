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
T = Te / 10


def mostrarValores():
    print("Pele = ", Pele / 1000)
    print("Cmn = ", Cmn)
    print("Ian = ", Ian)
    print("Kfluxo = ", Kf)
    print("B = ", B)
    print("Te = ", Te)
    print("Tm = ", Tm)
    print("T = ", T)


mostrarValores()

# # Estado permanente da velocidade e da corrente na armadura

# # Degrau
# W_ss = (Kf / (Ra * B)) / (Te * Tm + Kf**2 / (Ra * B)) * Vn
# Ia_ss = (B / J) / La / (Te * Tm + Kf**2 / (La * J)) * Vn

# Wn_ss = W_ss - (Ra / La) / J / (Te * Tm + Kf**2 / (La * J)) * Cmn
# Ian_ss = Ia_ss + Kf / (La * J) / (Te * Tm + Kf**2 / (La * J)) * Cmn

# # Rampa e Parabola tendem a infinito

# print(
#     f"\nVelocidade no estado permanente com aplicação de degrau, tensão nominal "
#     f"e a vazio\n{W_ss} rad/s\n{W_ss*30/pi} rpm"
# )
# print(
#     f"\nCorrente na armadura no estado permanente com aplicação de degrau,"
#     f" tensão nominal e a vazio\n{Ia_ss} A"
# )
# print(
#     f"\nVelocidade no estado permanente com aplicação de degrau,"
#     f" tensão nominal e carga nominal\n{Wn_ss} rad/s\n{Wn_ss*30/pi} rpm"
# )
# print(
#     f"\nCorrente na armadura no estado permanente com aplicação de degrau,"
#     f" tensão nominal e carga nominal\n{Ian_ss} A\n"
# )

# Torque = Pmec / W_ss
# print("Torque = ", Torque)
# print("K = ", [0.48, -97.1871])
# print("Ki = ", -97.6271)
# print("Ko = [133.0634; 1.89971]")

# print(
#     [
#         (1 - T / Tm) * (1 - T / Te) + (Kf**2) * T**2 / (La * J),
#         -(2 - T / Tm - T / Te),
#         1,
#     ]
# )

# print((-1 + T / Te) * (-1 + T / Tm) + (Kf**2) * T**2 / (La * J))

print((1 - T/Tm)*T/La)
