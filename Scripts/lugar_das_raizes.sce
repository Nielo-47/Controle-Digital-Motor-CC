gp = 0.007484/poly([0.919407 -1.8997 1], "z","coeff")
gc = (poly([-0.91411 1], "z","coeff") * poly([-0.91411 1], "z","coeff"))/poly([0 -1 1], "z","coeff")
//h = poly([-0.91411 1], "z","coeff")

q = gp*gc

close()
evans(q, 1000)
