clc

T = 0.00175;
ia_va = tf([1.25, -1.2496371, 0],[1, -1.8997097, 0.9140768], T);
w_ia = tf([0.00894035, 0, 0],[1, -0.49971867, -0.49984586], T);
w_ia = tf([0.00598709, 0.00299349, 0],[1, -0.49971867, -0.49984586], T);

a = 0.95;
b = a;
gpid = tf([1, -(a + b), a*b], [1, -1, 0], T);
gpi = tf([1, -a], [1, -1], T);

adc_10bits = 1023/5;
dac_10bits = Vn/1023;
ganho_amperimetro = (20-4)/Ian;
conversor_a_v = 1/4;
div_sinal = 5/10;
ganho_tacogerador = 0.0033 * 60/(2*pi);

qz_corrente = adc_10bits * dac_10bits * ia_va * w_ia* ganho_amperimetro * conversor_a_v * 0.1;
qz_velocidade =  adc_10bits * ganho_tacogerador * div_sinal * qz_corrente;

%controlSystemDesigner('rlocus', qz_velocidade);

%zgrid("new")
rlocus(qz_velocidade)


% Diferencas modelo 2 e 3 ordem 
% Funcão de transferencia controle em cascata 
