clc

T = 0.00175;
gpz = tf([1.25, -1.2496371, 0],[1, -1.8997097, 0.9140768], T);
a = 0.9;
b = a;
gpid = tf([1, -(a + b), a*b], [1, -1, 0], T);
gpi = tf([1, -a], [1, -1], T);

adc_10bits = 1023/5;
dac_10bits = Vn/1023;

ganho_amperimetro = (20-4)/400;
conversor_v_a = 1/4

gz = gpz * adc_10bits * dac_10bits;
hz = ganho_amperimetro * conversor_v_a;
qz = gz*hz;

controlSystemDesigner('rlocus', qz);

%zgrid("new")
%rlocus(qz);
