clear
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
N = 3000

//Determinando o período de amostragem
T = Te/10

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

//Definindo parâmetros da simulação
x = [0;0]
W(1,1) = 0
Ia(1,1) = 0
t(1,1) = 0
tempo = 0
u = [Vn; 0]
N= 3000 //Número de iterações

// Cálculo recursivo
for I=1:length(pras)
    tempo = tempo + T
    
    u(1,1) = pras(I)
   
    x = A*x + B*u
    
    t(I+1,1) = tempo
    Ia(I+1, 1) = x(1,1)
    W(I+1,1) = x(2,1) 
end


sout = W
sins = pras
Y = [];
X = [];
for k = 3 :length(sout) -1
    disp(k)
    Y = [Y;sout(k)];
    X = [X; -sout(k-1) -sout(k-2) sins(k)]; 
end

Xt = X';
pseudoinv = inv(Xt*X);
theta = pseudoinv*Xt*Y;

W_MQ = X*theta

//Plotando o grafico da velocidade
clf(1)
figure(1)
plot(t(1:length(W_MQ)), W(1:length(W_MQ)), 'r')
plot(t(1:length(W_MQ)), W_MQ, 'b')
plot(t(1:length(W_MQ)), pras(1:length(W_MQ)), 'g')
title('Velocidade do eixo' )
ylabel( 'Velocidade (rad/s)')
xlabel( 'Tempo (s)')

