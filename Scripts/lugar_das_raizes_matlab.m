gpz = tf([0.0058540 0 0],[1 -1.9224928 0.9337476])
gcz = tf([1 -(0.9 + 0.9) 0.9*0.9], [1 -1 0])
cond_sinal = 3/14
adc_10bits = 1023/5
conv_cacc = 400/1023
conv_rads_rpm = 60/(2*pi)
ganho_tacogerador = 0.007

gz = adc_10bits * gcz * conv_cacc * gpz
hz = conv_rads_rpm * ganho_tacogerador * cond_sinal

qz = gz*hz

rlocus(qz)