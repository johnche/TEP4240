clc
clear all

wind_speed = 10; % m/s
rotor_radius = 5; % m
fs = wind_speed * pi*rotor_radius^2;

Tr = .5; % assumption

Gg = .9; % assumption

speaker_radius = .05; %m
NB = 100; % assumption
Gh = 2*pi*speaker_radius*NB; %

Ir = 500; % radius * 50kg/m * 4 * .5 * radius^2 * 4% (alt tatt fra løse luften)
Ig = 10; % assumption
Ih = .1; % assumption
C = .1;
Rr = 10; % assumption
Rg = 5; % assumption
Rf = 1;
Rh = 1; % assumption
A = @(t) sin(220*pi*t);

pm_0 = 0; ph_0 = 0;
p_0 = [pm_0; ph_0];

dPa_dt = Tr*Gg*fs;
dPm_dt = @(t, p) Tr*Gg*fs - p(1)*Rg/Ig;
dPh_dt = @(t, p) ((A(t)*dPa_dt*Gh)/Rf-p(2)*Rh/Ih)/(1+C*Gh*Gh*p(2)/Ih);

dp_dt = @(t, p) [ dPm_dt(t, p) ; dPh_dt(t, p) ];

[t, p] = ode45(dp_dt, linspace(0, 10000, 1000), p_0);

%plot(t, p)
%legend('Pm', 'Ph')

plot(t, p(:,2))
legend('Linear momentum speaker membrane')
xlabel('Time (s)')
ylabel('Linear momentum (N s)')