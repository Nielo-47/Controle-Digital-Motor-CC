clc

T = 0.00175;
gpz = tf([1.25, -1.2496371, 0],[1, -1.8997097, 0.9140768], T);
a = 0.7;
b = a;
gpid = tf([1, -(a + b), a*b], [1, -1, 0], T);
gpi = tf([1, -a], [1, -1], T);

adc_10bits = 1023/5;
dac_10bits = Vn/1023;

ganho_amperimetro = (20-4)/260;
conversor_a_v = 1/4;

gz = gpz * adc_10bits * dac_10bits * gpid;
hz = ganho_amperimetro * conversor_a_v;
qz = gz*hz;

controlSystemDesigner('rlocus', qz);

%zgrid("new")
%rlocus(qz);
