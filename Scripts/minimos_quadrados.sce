// Simulação do motor submetido a entradas na forma degrau, PRAS e PRBS com
// estimação dos parâmetros usando mínimos quadrados
clc

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


// Definindo funções 
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

function [aproximacao, theta] = calcularMinimosQuadrados(entradas, saidas)
    Y = [];
    X = [];
    for k = 3 :length(saidas) -1
        Y = [Y;saidas(k)];
        X = [X; -saidas(k-1) -saidas(k-2) entradas(k)]; 
    end

    Xt = X';
    pseudoinv = inv(Xt*X);
    theta = pseudoinv*Xt*Y;
    aproximacao = X*theta
endfunction

function plotarResultadoDaSimulacao(saidas,saidas_MQ, entrada, t, J)
    cor_saida = 'r'
    cor_mq = 'b'
    cor_entrada = 'g'

    //Plotando o grafico da velocidade
    /*
    clf(J)
    figure(J)
    plot(t(4:length(t)), saidas(1)(4:length(t)), cor_saida)
    plot(t(4:length(t)), saidas_MQ(1), cor_mq)
    plot(t(4:length(t)), entrada(3:length(entrada)), cor_entrada)
    title('Velocidade do eixo' )
    ylabel('Velocidade (rad/s)')
    xlabel('Tempo (s)')
    gca().children.children().thickness = 1.5;
    */
    //Plotando grafico da corrente
    clf(J + 3)
    figure(J + 3)
    plot(t(4:length(t)), saidas(2)(4:length(t)), cor_saida)
    plot(t(4:length(t)), saidas_MQ(2), cor_mq)
    plot(t(4:length(t)), entrada(3:length(entrada)), cor_entrada)
    title('Corrente na armadura')
    ylabel('Corrente (A)')
    xlabel('Tempo (s)')
    gca().children.children().thickness = 1.5;
    
endfunction

//Gerando sinal de entrada degrau
degrau = ones(N, 1) * Vn 

// Gerando sinal de entrada PRAS
pras = [Vn]
rand("uniform")
for I=1:N
    if(modulo(I, 500) == 0 && I > 0)
        pras(I+1) = rand() * 2 * Vn
    else
        pras(I+1) = pras(I)
    end 
end

// Gerando sinal de entrada PRBS
prbs = prbs_a(N, 20)

for K = 1:length(prbs)
    if(K < round(N/4))
        prbs(K) = Vn
    else
        prbs(K) = prbs(K) * 125 + Vn 
    end
end

// Calculando e plotando simulação
entradas = list(degrau, pras, prbs)

for J=1:length(entradas)
    [W, Ia, t] = calcularSinalDeSaida(entradas(J));
    [W_MQ, theta_W] = calcularMinimosQuadrados(entradas(J), W);
    [Ia_MQ, theta_Ia] = calcularMinimosQuadrados(entradas(J), Ia);
    disp("Velocidade")
    disp(theta_W)
    disp("Corrente")
    disp(theta_Ia)
    
   plotarResultadoDaSimulacao(list(W, Ia),list(W_MQ, Ia_MQ), entradas(J), t, J);
end







