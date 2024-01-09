% Simulação do motor submetido a entradas na forma degrau, PRAS e PRBS com
% estimação dos parâmetros usando mínimos quadrados
clc

% Definição dos parâmetros do motor
Pmec = 95 * 10^3
n = 0.913
Vn = 400
Wn = 1890 * 3.141592 / 30
Ra = 0.08
J = 0.56
La = 1.4 * 10^-3
Pele = Pmec / n
Cmn = Pmec / Wn
Ian = Pele / Vn
Kf = (Vn - Ian * Ra) / Wn
B = (Kf * Ian - Cmn) / Wn
Tm = J / B
Te = La / Ra

%Determinando o período de amostragem e numero de iterações
T = Te/10
N = 3000

%Determinando os coeficientes da matriz A
a11 = 1 - T/Te; a12 = -Kf*T/La;
a21 = Kf * T/J; a22 = 1-T/Tm;

A = [a11 a12; a21 a22]

%Determinando os coeficientes da matriz B
b11 = T/La; b12 = 0;
b21 = 0; b22 = -T/J;

B = [b11 b12; b21 b22]

%Definindo a matriz C
C = [1 0; 0 1]


%Gerando sinal de entrada degrau
degrau = ones(N, 1) * Vn; 

% Gerando sinal de entrada PRAS
pras = [Vn];
for I=1:N
    if(mod(I, 500) == 0 && I > 0)
        pras(I+1) = rand() * 2 * Vn;
    else
        pras(I+1) = pras(I);
    end 
end

% Calculando e plotando simulação
entradas = {degrau, pras};

for J=1:length(entradas)
    [W, Ia, t] = calcularSinalDeSaida(entradas(J), Vn, T);
    [W_MQ, theta_W] = calcularMinimosQuadrados(entradas(J), W);
    [Ia_MQ, theta_Ia] = calcularMinimosQuadrados(entradas(J), Ia);

    disp("Velocidade")
    disp(theta_W)
    disp("Corrente")
    disp(theta_Ia)

    plotarResultadoDaSimulacao(list(W, Ia),list(W_MQ, Ia_MQ), entradas(J), t, J);
end

% Definindo funções
function [W, Ia, t] = calcularSinalDeSaida(entrada, Vn, T)
    x = [0;0]
    W(1,1) = 0
    Ia(1,1) = 0
    t(1,1) = 0
    tempo = 0
    u = [Vn; 0]

    for I=1:length(entrada)
        tempo = tempo + T
        
        u(1,1) = entrada(I)
       
        x = A*x + B*u
        
        t(I+1,1) = tempo
        Ia(I+1, 1) = x(1,1)
        W(I+1,1) = x(2,1)
    end
end

function [aproximacao, theta] = calcularMinimosQuadrados(sins, sout)
    Y = [];
    X = [];
    for k = 3 :length(sout) -1
        Y = [Y;sout(k)];
        X = [X; -sout(k-1) -sout(k-2) sins(k)]; 
    end

    Xt = X';
    pseudoinv = inv(Xt*X);
    theta = pseudoinv\Xt*Y;
    aproximacao = X*theta
end






