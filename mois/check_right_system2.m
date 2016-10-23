u2 = 110 + 0i
u1 = 115 + 0i
y22 = 0.02 - 0.04i
y21 = -0.02 + 0.04i

t = conj(u2)*(y22*u2 + y21*u1)
real(t)
imag(t)