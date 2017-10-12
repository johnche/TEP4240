function d_dt = eulerStep(t, y)
global h_max h_omega I C R g

h_dot = h_max*h_omega*cos(h_omega*t);
d_dt=zeros(2,1);

q = y(1);
p = y(2);

q_dot = h_dot - p/I;
d_dt(1) = q_dot;
d_dt(2) = I*g + R*q_dot + q/C;