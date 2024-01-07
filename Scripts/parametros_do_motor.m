% Definição dos parâmetros do motor
Pmec = 95 * 10^3;
n = 0.913;
Vn = 400;
Wn = 1890 * 3.141592 / 30;
Ra = 0.08;
J = 0.56;
La = 1.4 * 10^-3;
Pele = Pmec / n;
Cmn = Pmec / Wn;
Ian = Pele / Vn;
Kf = (Vn - Ian * Ra) / Wn;
B = (Kf * Ian - Cmn) / Wn;
Tm = J / B;
Te = La / Ra;
T = Te/10;