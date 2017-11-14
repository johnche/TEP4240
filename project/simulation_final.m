clc
clear all

wind_speed = 8; % m/s
rotor_radius = 1; % m
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
A = @(t) sin(220*2*pi*t);

pm_0 = 0; ph_0 = 0;
p_0 = [pm_0; ph_0];

dPa_dt = Tr*Gg*fs;
dPm_dt = @(t, p) Tr*Gg*fs - p(1)*Rg/Ig;
dPh_dt = @(t, p) ((A(t)*dPa_dt*Gh)/Rf-p(2)*Rh/Ih)/(1+C*Gh*Gh*p(2)/Ih);

dp_dt = @(t, p) [ dPm_dt(t, p) ; dPh_dt(t, p) ];

[t, p] = ode15s(dp_dt, linspace(0, 1, 10000), p_0);

%plot(t, p)
%legend('Pm', 'Ph')


speaker_force = zeros(size(t));

for i = 1:size(t)
    speaker_force(i) = dPh_dt(t(i), p(i,:));
end

figure(1)
plot(t, speaker_force)
legend('Induced force speaker membrane')
xlabel('Time (s)')
ylabel('Force (N)')

figure(2)
clf
hold on
plot(t, speaker_force)
plot(t, A(t))
hold off
ylabel('Force (N)')
legend('Induced force speaker membrane', 'Mic input')
xlabel('Time (s)')