gp = poly([0 0.3624], "z","c")/poly([-0.819 1], "z","c")
a = 0.5
b = 0.5
gc = poly([-a 1], "z","coeff")/poly([-1 1 ], "z","coeff")
//h = poly([-0.91411 1], "z","coeff")

q = gp*gc

close()
evans(q, 1000)
