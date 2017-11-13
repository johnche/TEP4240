clc
clear all

fs = 100;
Gm = 1;
Gh = 1;
Ir = .1;
Im = .1;
Ih = .1;
C = .1;
Rr = 1;
Rm = 1;
Rf = 1;
Rh = 1;
Tr = 1;
A = @(t) sin(440*pi*t);

pm_0 = 0; ph_0 = 0;
p_0 = [pm_0; ph_0];

dPa_dt = Tr*Gm*fs;
dPm_dt = @(t, p) Tr*Gm*fs - p(1)*Rm/Im;
dPh_dt = @(t, p) ((A(t)*dPa_dt*Gh)/Rf-p(2)*Rh/Ih)/(1+C*Gh*Gh*p(2)/Ih);

dp_dt = @(t, p) [ dPm_dt(t, p) ; dPh_dt(t, p) ];

[t, p] = ode45(dp_dt, linspace(0, 1, 100000), p_0);

%plot(t, p)
%legend('Pm', 'Ph')

plot(t, p(:,2))
legend('Ph')