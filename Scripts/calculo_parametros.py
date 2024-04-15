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


# A1: Tanque 0 entre 0-20 m\(^3\)
# A2: Tanque 0 entre 20-60 m\(^3\)
# B1: Tanque 2 entre 0-10 m\(^3\)
# B2: Tanque 2 entre 10-30 m\(^3\)
# B3: Tanque 2 entre 30-50 m\(^3\)
# C1: Tanque 3 entre 0-20 m\(^3\)
# C2: Tanque 3 entre 20-40 m\(^3\)


# Se LL Tanque 0 inativo & A1 = Verdadeiro \\
# Se LL Tanque 0 ativo & A2 = Verdadeiro \\
# Se LL Tanque 2 inativo & B1 = Verdadeiro \\
# Se LL Tanque 3 inativo & C1 = Verdadeiro \\
# Se LL Tanque 3 ativo & C2 = Verdadeiro  \\

# Se HL ativo em todos os tanques & 60/50/40  \\
# Se LL inativo em todos os tanques & 0-20/0-10/0-20  \\
# Se LL Tanque 0 inativo e HL Tanque 3 e Tanque 2 ativos & A1/50/40 \\
# Se LL Tanque 0 e Tanque 2 inativos e LL Tanque 3 ativo e HL Tanque 3 inativo & Pular para etapa 2 \\

# \item Acionar Bomba 02 até LL Tanque 0 inativo ou HL Tanque 2 ativo
# \item Acionar Eletrovalvula 23 até LL Tanque 2 inativo ou HL Tanque 3 ativo
# \item Repetir até LL Tanque 0 inativo ou HL Tanque 2 e Tanque 3 ativos

# Se LL tq3 ativo & C1 = Falso e C2 = Verdadeiro \\
# Se LL tq2 ativo & B1 = Falso \\
# Se LL tq3 ativo e LL tq2 inativo & B2 = Verdadeiro \\
# Se HL tq3 ativo e LL tq2 ativo  & B3 = Verdadeiro e B2 = Falso \\

# Se LL tq0 inativo e HL tq2 e tq3 ativos & 20/50/40 \\
# Se LL tq0 ativo e HL tq2 e tq3 ativos & A2/50/40 \\
# Se todos LL inativos & A1/B1/C1 \\

# Se LL tq2 inativo & A?/B1/20 \\
# Se HL tq2 ativo e LL tq3 inativo & A?/50/20 \\
# Se HL tq2 inativo e LL ativo e LL tq3 inativo & A?/B?/20 \\
# Se HL tq2 ativo e LL tq3 ativo & A?/50/C \\

