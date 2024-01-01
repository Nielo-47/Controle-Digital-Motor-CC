// Simulação Motor CC com variação de carga e variação paramétrica

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

//Determinando o período de amostragem
T = Te/10

//Determinando os coeficientes da matriz A
a11 = 1 - T/Te; a12 = -Kf*T/La;
a21 = Kf * T/J; a22 = 1-T/Tm;

A = [a11 a12; a21 a22]

A = [ 1 - T/Te, -Kf*T/La; Kf * T/J,  1-T/Tm ] 

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
for I=1:N
    tempo = tempo + T

    if (I==500) // Adicionando carga nominal
        u(2,1) = Cmn
    end 
    
    if (I==1500) // Elevando a resistência da armadura
        Ra = 0.5
        Te = La / Ra
        a11 = 1 - T/Te
        A = [a11 a12; a21 a22]
    end
    
    if (I==2300) // Adicionando carga nominal
        u(2,1) = 0
    end 
    
    x = A*x + B*u
    
    t(I+1,1) = tempo
    Ia(I+1, 1) = x(1,1)
    W(I+1,1) = x(2,1) 
end

//Plotando o grafico da velocidade
clf(1)
figure(1)
plot(t, W, 'r')
title('Velocidade do eixo' )
ylabel( 'Velocidade (rad/s)')
xlabel( 'Tempo (s)')
colordef("white")
a=gca().children.children();
a.thickness = 3

//Plotando o grafico da corrente na armadura
clf(2)
figure(2)
plot(t, Ia, 'b')
title('Corrente na armadura' )
ylabel( 'Corrente na armadura (A)')
xlabel( 'Tempo (s)')
a=gca().children.children();
a.thickness = 3




