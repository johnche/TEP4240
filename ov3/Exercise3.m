clear all
clc
%%Constants
global h_max h_omega I C R g

I = 70;
g = -9.81;
Amptude = .1;
k = I*abs(g)/Amptude;
C= 1/k;

omega = sqrt(k/I);
period = 2*pi/omega;
dampingtime = .2;
R = I/dampingtime;
tmax = 5;

fprintf(' spring constant k = %i\n', k)
fprintf(' natural frequency omega = %i\n', omega)
fprintf(' one period = %f\n', period)
fprintf(' damping constant R = %i\n', R)

%%First Simulation: Finding constants
%A person with mass m jumps on the bike at time t=0
%Expected behavoiur: The displacement u should level off after a while
%-------------------------------------------------------------------------

h_max = 0;
h_omega = 0;
tspan = linspace(0, tmax);

%initial values
x_0 = 0;        %displacement
u_0 = 0;        %velocity

[t, y] = ode45(@eulerStep, tspan, [x_0, u_0]); 

figure(1)
plot(t, x_0 - y(:,1), t, y(:,2)/I)
legend('x (q)','u (p)')
title(sprintf('Person with mass = %i\n jumps on the bike', I),'FontSize',18);
text(1.0, -0.35,'The displacement oscillates nicely towards the Amplitude')
grid on
hold on

%%Second simulation
% Simulates the vertical motion of when he's cycling at constant speed and 
% the ground level changes as h(y) 
%-------------------------------------------------------------------------

%initial values
x_0 = y(end, 1); %displacement
u_0 = 0;         %velocity

h_max = Amptude;
h_0 = [1 5 10 20 100];
k = 1;
for h_omega = h_0
    k = k + 1;
    tmax = 10*pi/h_omega;
    [t, y] = ode15s(@eulerStep, [0 tmax], [x_0, u_0]); 
    figure(k)
    plot(t,x_0-y(:,1)+h_max*sin(t.*h_omega),t,h_max*sin(t.*h_omega),'r')
    legend('x','h')
    title(['\Omega_{ground}/Natural frequency = ',num2str(h_omega/omega)],'FontSize',16);
    grid on
    drawnow
    hold off
end

%% Third simulation: 
% 
%--------------------------------------------------------------------------

x_0 = Amptude;    % Step height
u_0 = 0;
hmax = 0;
tmax = 2;
tspan = linspace(0, tmax);

[t,y]=ode45(@eulerStep,tspan,[x_0; u_0]);

% Plotting: The biker falls 50% lower than the step!
k = k+1;
figure(k)
plot(t,x_0-y(:,1),[0 0 tmax],[x_0 0 0],'r','LineWidth',3)
legend('x','Step')
title('m bikes down a step','FontSize',16);
%% Function file:
% <include>eulerStep.m</include>