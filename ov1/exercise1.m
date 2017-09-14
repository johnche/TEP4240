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

dy = @(t, y) 5*(y - t^2);

%Analytic solution:
ta=linspace(0,tmax);
ya=ta.^2+2*ta/5+2/25;

%Numerial solution ODE45,ODE23, ODE113, ODE15s, ODE23s, ODE23t, ODE23tb
[t45, y45] = ode45(dy, ta, y0);
[t23, y23] = ode23(dy, ta, y0);
[t113, y113] = ode113(dy, ta, y0);
[t15s, y15s] = ode15s(dy, ta, y0);
[t23s, y23s] = ode23s(dy, ta, y0);
[t23t, y23t] = ode23t(dy, ta, y0);
[t23tb, y23tb] = ode23tb(dy, ta, y0);

figure(1)
title('Solution to dy/dt = 5(y - t^2)')
axis([0 tmax 0 30])
xlabel('Time')
ylabel('Y')
grid
hold on
plot(ta,ya)
plot(t45, y45)
plot(t23, y23)
plot(t113, y113)
plot(t15s, y15s)
plot(t23s, y23s)
plot(t23t, y23t)
plot(t23tb, y23tb)
legend('Analytic', 'ode45')
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
%e = 0.001;
%f = 0.001;
%g = 0.1;
%h = 0.001;
%i = 0.001;
tmax = 20.;
dt = .01;

% Initial conditions:
R = 1000.0;
F = 100.0;
%H = 10.0;

% Prepare figure:
figure(2)
clf
title('Concentration of Rabbits and Foxes on an island')
axis([0 tmax 0 R*3])
xlabel('Time [year]')
ylabel('Population')
grid
hold on

% Main loop:
for t = 0:dt:tmax
%  ?
end

legend('Rabbits','Foxes')
hold off
