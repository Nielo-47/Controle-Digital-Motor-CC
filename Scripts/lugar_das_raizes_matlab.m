clc

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

%W/Va
%F.T. continua 
gps_w = tf(Kf/(Ra*B),[Te*Tm, Te+Tm, 1 + Kf^2/(Ra*B)])

% F.T. Discreta
gpz_w = tf(T^2*Kf/(La*J), [1, -(1-T/Te + 1+T/Tm),(1-T/Te)*(1+T/Tm) + Kf^2*T^2/(La*J)], T)

%controlSystemDesigner('rlocus', gps_w)
controlSystemDesigner('rlocus', gpz_w)

%Ia/Va
%F.T. continua 
gps_Ia = tf([Tm/Ra, 1/Ra],[Te*Tm, Te+Tm, 1 + Kf^2/(Ra*B)])

% F.T. discreta
gpz_Ia = tf([T/La, -(1-T/Tm)*T/La], [1, -(1-T/Te + 1+T/Tm),(1-T/Te)*(1+T/Tm) + Kf^2*T^2/(La*J)], T)

%controlSystemDesigner('rlocus', gps_Ia)
%controlSystemDesigner('rlocus', gpz_Ia)

