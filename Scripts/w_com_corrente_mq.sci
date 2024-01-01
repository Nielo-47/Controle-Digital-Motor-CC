// Simulação do motor submetido a entrada PRBS com
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

// Definindo funções 
function [aproximacao] = calcularMinimosQuadrados(entradas, saidas)
    Y = [];
    X = [];
    for k = 3 :length(saidas) -1
        Y = [Y;saidas(k)];
        X = [X; -saidas(k-1) -saidas(k-2) entradas(k)]; 
    end

    Xt = X';
    pseudoinv = inv(Xt*X);
    theta = pseudoinv*Xt*Y;
    disp(theta)
    aproximacao = X*theta
endfunction

function plotarResultadoDaSimulacao(saidas,saidas_MQ, entrada, t, J)
    cor_saida = 'r'
    cor_mq = 'b'
    cor_entrada = 'g'
    
    //Plotando grafico da corrente
    clf(J + 3)
    figure(J + 3)
    plot(t(4:length(t)), saidas(4:length(t)), cor_saida)
    plot(t(4:length(t)), saidas_MQ, cor_mq)
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


deff('u=timefun(t)','u=400')

Ia = csim(timefun,t, tf);

t = 0:T:T*N;

deg = [Vn]

for tem = 1: N
    deg(tem) = timefun(tem);
end

tf = poly([Ra/(Te*Tm),1/(Te*Ra)], "s", "c")/ poly([1/(Te*Tm),(Te+Tm)/(Te*Tm), 1], "s", "c")
[f,xopt, gopt] = leastsq(list(myfun,tm,ym,wm),x0)



//Ia_MQ = calcularMinimosQuadrados(deg, Ia);

//for J=1:length(entradas)
//Ia = csim(degrau,t, tf);
//Ia_MQ = calcularMinimosQuadrados(entradas(J), Ia);
    //plotarResultadoDaSimulacao(Ia, Ia_MQ, entradas(J), t, J);
//end







