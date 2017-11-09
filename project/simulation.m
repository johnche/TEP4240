G1 = 1;
G2 = 1;
G3 = 1;
G4 = -10;
fs = 1;
I1 = 1;
I2 = 1;
I3 = 1;
C = 1;
R = 1;

p1_0 = 0; p2_0 = 0; q_0 = 1;
x_0 = [p1_0; p2_0; q_0];
dx_dt = @(t, x) [ G1*fs - G2*x(2)/I2 ; G2*x(1)/I1 - G4*x(3)/(C*G3) ; (G4*x(3)/(C*G3) - x(3)/C)/(R*(1 + I3/(C*G3))) ];

[t, x] = ode45(dx_dt, linspace(0, 10, 10000), x_0);

plot(t, x)
legend('p1', 'p2', 'q')