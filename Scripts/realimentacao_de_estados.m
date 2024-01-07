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

%Determinando o período de amostragem
T = Te/10;

%Determinando os coeficientes da matriz A
a11 = 1 - T/Te; a21 = Kf * T/J;
a12 = -Kf*T/La; a22 = 1-T/Tm;

%Determinando os coeficientes da matriz B
b1 = -T/La;
b2 = 0;

%Determinando os coeficientes da matriz C
c1 = 0; c2 = 1;

%Definindo o polinômio desejado (pólos reais e iguais a 0.5) 
raiz = 0.5;
p = poly([raiz raiz raiz]);

%Calculo de K1, K2 e Ki
coeff_determinante = [
    0, 0, 1;
    b1, b2, -a22-a11;
    a12*b2-b1*a22, b1*a21-b2*a11, -a12*a21;
];

coeff_desejados = [
    p(2) + a11 + a22; 
    p(3)-a11*a22+a12*a21; 
    p(4);
];

k_c = linsolve(coeff_determinante,coeff_desejados);

coeff_vetor_k_c = [
    a11-1, a21, c1*a11+c2*a21;
    a12, a22-1, c1*a12+c2*a22;
    b1+c1*b1+c2*b2, b2, 0;
]

coeff_k_c = [
    k_c(1); 
    k_c(2); 
    k_c(3)-1
]

k = linsolve(coeff_vetor_k_c, coeff_k_c);

k1 = k(1)
k2 = k(2)
ki = k(3)

%
% z(-a22+ko2*c2+ko1*c1-a11)
% (a11*a22 - a11*ko2*c2 + ko1*c1*a22 - a12*a21 + a12*ko2*c1 + ko1*c2*a21)

%ko1(c1) + ko2(c2) = a11 + a22
%ko1(c2*a21 + c1*a22) + ko2(a12*c1 -a11*c2) = a12*a21 - a11*a22

ko = linsolve([
    c2*a21+c1*a22, a12*c1-a11*c2; 
    c1, c2;   
], [ a12*a21-a11*a22;a11+a22])

% 
% A = [0, 0, -1;
%      b1, b2 ,a22+a11;
%      -a12*b2-b1*a22,-b1*a21-a11*b2,-a11*a22+a12*a21
%     ]
% B = [
%     p(2) + a22 + a11;
%     p(3)- a11*a22 + a12*a21;
%     p(4)
%     ]
% 
% linsolve(A,B)

% syms k1 k2 k3
% eqn1 = k3 == -p(2) - a22 - a11;
% 
% eqn2 = k3*(a22+a11) + b1*k1 + b2*k2  == p(3)- a11*a22 + a12*a21;
% 
% eqn3 = k3*(-a11*a22 + a12*a21) + k2*(-b1*a21-a11*b2)+ k1*(-a12*b2-b1*a22) == p(4);
% 
% sol = solve([eqn1, eqn2, eqn3], [k1, k2, k3]);
% 
% k_c = [sol.k1 sol.k2 sol.k3]
% 
% [A,B] = equationsToMatrix([eqn1, eqn2, eqn3], [k1, k2, k3])
% 
% a22 + a11
% [0.4890 107.8312] 107.6189 
