
// Definição dos parâmetros do motor
Pmec = 95 * 10**3
n = 0.913
Vn = 400
Wn = 1890 * 3.141592 / 30
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

//Determinando o período de amostragem e numero de iterações
T = Te/10
N = 3000

//Determinando os coeficientes da matriz A
a11 = 1 - T/Te; a12 = -Kf*T/La;
a21 = Kf * T/J; a22 = 1-T/Tm;

A = [a11 a12; a21 a22]

//Determinando os coeficientes da matriz B
b11 = T/La; b12 = 0;
b21 = 0; b22 = -T/J;

B = [b11 b12; b21 b22];

//Definindo a matriz C
C = [1 0; 0 1]


function [aproximacao, theta] = calcularMinimosQuadrados(entradas, saidas)
    Y = [];
    X = [];
    for k = 1 :length(saidas) -3
        Y = [Y;saidas(k+2)];
        X = [X; -saidas(k+1) -saidas(k) entradas(k) entradas(k + 1)];
    end

    pseudoinv = pinv(X)
    theta = pseudoinv*Y;
    aproximacao = X*theta
endfunction


function [W, Ia, t] = calcularSinalDeSaida(entrada)
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
endfunction

// Gerando sinal de entrada PRBS
prbs = prbs_a(N, 20)

for K = 1:length(prbs)
    if(K < round(N/4))
        prbs(K) = Vn
    else
        prbs(K) = prbs(K) * 125 + Vn 
    end
end


[W, Ia, t] = calcularSinalDeSaida(prbs);
[aprox, theta] = calcularMinimosQuadrados(prbs, Ia)
disp(theta)

