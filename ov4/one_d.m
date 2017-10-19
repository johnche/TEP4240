clear all
clc
R = 100;
m = 2;
I = m;
g = -10;
c = 10;
x_0 = [0 ; 0]; % [q_0 ; p_0]
dx_dt = @(t, x) [x(2)/I ; m*g - x(1)/c - R*x(2)/I];
%x = [dp_dt ; dq_dt];
[t, x] = ode45(dx_dt, 1:.1:200, x_0);
plot(t, x)
legend('p', 'q')