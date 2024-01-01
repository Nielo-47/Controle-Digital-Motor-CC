clc

T = 0.00175;
gpz = tf([0.0058540, 0, 0],[1, -1.9224928, 0.9337476], T);
gcz = tf([1, -(0.8 + 0.8), 0.8*0.8], [1, -1, 0], T);

amp_sinal = 2;
div_sinal = 5/10;
adc_10bits = 1023/5;
dac_10bits = 5/1023;
conv_cacc = 600/10;
ganho_tacogerador = 0.0033 * 60/(2*pi);

gz = gpz * amp_sinal * adc_10bits * dac_10bits * conv_cacc; 
hz = ganho_tacogerador * div_sinal;
qz = gz*hz;

%zgrid("new")
%rlocus(qz);

gcz = tf([1, -0.5], [1, -1], T);
gz_pi = gz * gcz;
qz = gz_pi*hz;
%rlocus(qz);

gcz = tf([1, -(0.9 + 0.9), 0.9*0.9], [1, -1, 0], T);
gz_pi = gz * gcz;
qz = gz_pi*hz;
rlocus(qz);

% cond_sinal = 3/14;
% adc_10bits = 1023/5;
% conv_cacc = 400/1023;
% conv_rads_rpm = 60/(2*pi);
% ganho_tacogerador = 0.007;

% gpz = tf([0.007484], [1 -1.8997 0.91407], T)
% gcz = tf([1, -1], [1, 0], T)


%gpz = tf([1 0 -0.81], [1 -2 0.96], T)
%gcz = tf([1 -0.7], [1 -1], T)

%zpk(0, [0.9512, 0.9048, 0.8187], 0.0008413);
%gz = gpz * gcz *adc_10bits * conv_cacc
%hz = cond_sinal * conv_rads_rpm * ganho_tacogerador;


