clc

T = 0.00175;
gpz = tf([0.0058540, 0, 0],[1, -1.9224928, 0.9337476], T);
a = 0.9;
b = a;
gpid = tf([1, -(a + b), a*b], [1, -1, 0], T);
pi = 3.1415;
gpi = tf([1, -a], [1, -1], T);

div_sinal = 5/10;
adc_10bits = 1023/5;
dac_10bits = Vn/1023;

ganho_tacogerador = 0.0033 * 60/(2*pi);

gz = gpz * adc_10bits * dac_10bits * gpi;
hz = ganho_tacogerador * div_sinal;
qz = gz*hz;

%1.25*z^2  - 1.2496371*z
% z^2 - 1.8997087*z + 0.9140768
controlSystemDesigner('rlocus', qz);

%zgrid("new")
%rlocus(qz);
