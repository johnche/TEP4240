% TEP4240 SYSTEMSIMULATION  EXERCISE 1.
% Problem 1: Use of ODE-solvers on a simple but nasty problem.
% Solve 
%
%      dy/dt = 5(y - t^2)
%
% for t=0 to 5 with initial condition y(0)=2/25.
% Use first order Euler method, ODE45,ODE23, ODE113, ODE15s, ODE23s, ODE23t, ODE23tb
% and compare with the analytical solution y=t^2+2t/5+2/25.
% Plot the different solutions in the same figure. 
% Can you give an explanation to the strange results?
% The following code is a beginning on problem 1, just plotting the
% analytical solution:

clear all
close all
clc
tmax=5;
y0=2/25;


%Analytic solution:
t=linspace(0,tmax);
ya=t.^2+2*t/5+2/25;


dy_dt = @(t, y) 5*(y - t^2);
%Euler method
iterations = length(t);
ye = zeros(iterations,1);
ye(1) = y0;
h = t(2) - t(1);
for index = 2:iterations
    ye(index) = ye(index-1) + h .* dy_dt(t(index-1),ye(index-1));
end

%Numerial solution ODE45,ODE23, ODE113, ODE15s, ODE23s, ODE23t, ODE23tb
[t45, y45] = ode45(dy_dt, t, y0);
[t23, y23] = ode23(dy_dt, t, y0);
[t113, y113] = ode113(dy_dt, t, y0);
[t15s, y15s] = ode15s(dy_dt, t, y0);
[t23s, y23s] = ode23s(dy_dt, t, y0);
[t23t, y23t] = ode23t(dy_dt, t, y0);
[t23tb, y23tb] = ode23tb(dy_dt, t, y0);

figure(1)
title('Solution to dy/dt = 5(y - t^2)')
axis([0 tmax 0 30])
xlabel('Time')
ylabel('Y')
grid
hold on
plot(t,ya)
plot(t,ye)
plot(t45, y45)
plot(t23, y23)
plot(t113, y113)
plot(t15s, y15s)
plot(t23s, y23s)
plot(t23t, y23t)
plot(t23tb, y23tb)
legend('Analytic','Euler method','ODE45','ODE23','ODE113','ODE15s','ODE23s','ODE23t','ODE23tb')
hold off


% Problem 2: Population balance Rabbits/Foxes
% We model the concentration of Rabbits (R) and Foxes (F) on an island:
% 
%     dR/dt = aR - bRF
%     dF/dt = -cF + dRF
%
% where a,b,c and d are constants. We seek the solution plotted for 20 years 
% forward in time. The task is:
%
% 2a)  Solve using forward Euler scheme.
% 2b)  Solve using ODE45.
% 2c)  Add Hunters (H) on the island so that the model now becomes
% 
%     dR/dt = aR - bRF - eRH
%     dF/dt = -cF + dRF - fFH
%     dH/dt = -gH + hRH + iFH
%
% where e,f,g,h and i are new constants.
%
% 2d)  Adjust the time for hunters so that they see the Rabbit/fox/hunter-situation
%      2 months later. (Tip: Use Euler, not ODE45, thats rather tricky)
%
% The following code is a beginning on 2a).

clear all   % Allways!
clc

% Constants (Scaled so that the time unit is 1 year):
a = 1.0;
b = 0.002;
c = 0.5;
d = 0.001;
e = 0.001;
f = 0.001;
g = 0.1;
h = 0.001;
i = 0.001;
tmax = 20.;
dt = .01;

% Initial conditions:
R0 = 1000.0;
F0 = 100.0;
H0 = 10.0;

R = R0; F = F0; H = 0;
% Prepare figure:
figure(2)
clf
title('Concentration of Rabbits and Foxes on an island')
axis([0 tmax 0 R*3])
xlabel('Time [year]')
ylabel('Population')
grid
hold on
figure(2)
% Main loop:
for t = 0:dt:tmax
    if t == 2 % 0.17
        H = H0;
    end
    dR_dt = a.*R - b.*R.*F - e.*R.*H;
    dF_dt = -c.*F + d.*R.*F - f.*F.*H;
    dH_dt = -g.*H + h.*R.*H + i.*F.*H;
    R = R + dt*dR_dt;
    F = F + dt*dF_dt;
    H = H + dt*dH_dt;
    drawnow limitrate
    plot(t, R, 'ro', t, F, 'bo', t, H, 'go');
end

t=linspace(0,tmax);
d_dt = @(t, RF) [a.*RF(1) - b.*RF(1).*RF(2); -c.*RF(2) + d.*RF(1).*RF(2)];
[t45, RF45] = ode45(d_dt, t, [R0, F0]);
plot(t45, RF45(:,1),'r')
plot(t45, RF45(:,2),'b')

legend('Rabbits','Foxes','Hunters')
hold off
