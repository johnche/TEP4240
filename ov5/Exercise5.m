%% Problem 1: Finding the tallest point on an island

%z = sin(4*pi*x_1)*sin(5*pi*x_2)*(2 - x_1)*(2 - x_2); %%x in km
%z = -z; %% set z to negtive in order to use fmincon

%Quadratic:


%Circular: 


%% Problem 2: Find the optimal values for R and C.

t = 10*pi:0.1:12*pi;
v = 1;
omega = 1;
I = 0.3;
R = 1;
C = 1;

T=0:pi:12*pi;
fs=interp1(T,cos(T),t,'nearest');

q_0 = 0;
p_0 = 0;
y_0 = [q_0; p_0];

dy_dt = @(t, y) [fs-y(2)/I; y(1)/C+R*fs-R*y(2)/I];

[~,y]=ode45(dy_dt,0:pi:10*pi,y_0);
[t,y]=ode45(dy_dt,t,y(end,:));
cost=sum(abs(y(:,1)-cos(t))); % Here, y(:,1) is the mass position

hold on

plot(t, fs)
plot(t, y)

hold off