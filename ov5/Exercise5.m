%% Problem 1: Finding the tallest point on an island

z = @(x) -sin(4*pi*x(1)).*sin(5*pi*x(2)).*(2 - x(1)).*(2 - x(2)); %x in km
% set z to negative in order to use fmincon

options = optimoptions('fmincon', 'Display', 'off');

% Quadratic (x_1 and x_2 from 0 to 1):

testnormal = [0:0.1:1;0:0.1:1];

testfmincon = [0.1, 0.1];
xlength = length(testnormal);
xmax = 0;
lb = zeros(size(testfmincon));
up = ones(size(testfmincon));
[x, fval] = fmincon(z, testfmincon, [], [], [], [], lb, up, [], options);
for q=1:xlength
    xin = [testnormal(1, q), testnormal(2, q)];
    [x, fvalu] = fmincon(z, xin, [], [], [], [], lb, up, [], options);
    if(fvalu < xmax)
        xmax = fvalu;
    end
end
fprintf('Quadratic:\n')
fprintf('The highest peak is %f kms (fmincon)\n', -fval);
fprintf('The highest peak is %f kms (Iterating over all the points (x, x))\n', -xmax);

%# Circular (origo in x1 = x2 = 0.5 km and radius = 0.5 km): 

%circlepts = [0:0.05:1; 0:0.05:1];
tfminconcircle = [0.1, 0.1];
%xlength = length(circlepts);
xmaxcircle = 0;
[xvalcircle, fvalcircle] = fmincon(z, tfminconcircle, [], [], [], [], [], [], @confun, options);
x_1maxpoint = 0;
x_2maxpoint = 0;

for q=1:1000
     [x1, x2] = RanCircleP(0.5, 0.5, 0.5);
     [x, fvalu] = fmincon(z, [x1, x2], [], [], [], [], [], [], @confun, options);
     if(fvalu < xmaxcircle)
         xmaxcircle = fvalu;
         x_1maxpoint = x(1);
         x_2maxpoint = x(2);
     end
end
fprintf('Circular:\n')
fprintf('The highest peak is %f kms on point (%f, %f)(fmincon with different start values)\n',... 
                -xmaxcircle, x_1maxpoint, x_2maxpoint);
fprintf('The highest peak is %f kms on point (%f, %f) (fmincon startpoint(%f, %f)\n',...
    -fvalcircle, xvalcircle(1), xvalcircle(2), tfminconcircle(1), tfminconcircle(2));


%% Problem 2: Find the optimal values for R and C.

t = 10*pi:0.1:12*pi;
v = 1;
omega = 1;
I = 0.3;
R = 1;
C = 1;

T=0:pi:12*pi;
fs = @(t) (cos(t) >= 0) - (cos(t) < 0);

q_0 = 0;
p_0 = 0;
y_0 = [q_0; p_0];

dy_dt = @(t, y) [fs(t)-y(2)/I; y(1)/C+R*fs(t)-R*y(2)/I];

[~,y]=ode45(dy_dt,0:pi:10*pi,y_0);
[t,y]=ode45(dy_dt,t,y(end,:));
cost=sum(abs(y(:,1)-cos(t))); % Here, y(:,1) is the mass position

mincost = fmincon(@costfun, [1,10], [1,1], 200,[],[],[1,1], [],[], options);

hold on

plot(t, cos(t))
plot(t, arrayfun(fs, t))
plot(t, y)

hold off
legend('cos(t)', 'fs', 'q', 'p')

function cost=costfun(RC)
    t = 10*pi:0.1:12*pi;
    v = 1;
    omega = 1;
    I = 0.3;
    R = RC(1);
    C = RC(2);

    T=0:pi:12*pi;
    fs = @(t) (cos(t) >= 0) - (cos(t) < 0);

    q_0 = 0;
    p_0 = 0;
    y_0 = [q_0; p_0];
    dy_dt = @(t, y) [fs(t)-y(2)/I; y(1)/C+R*fs(t)-R*y(2)/I];
    [~,y]=ode45(dy_dt,0:pi:10*pi,y_0);
    [t,y]=ode45(dy_dt,t,y(end,:));
    cost=sum(abs(y(:,1)-cos(t))); % Here, y(:,1) is the mass position
    disp(cost)
    plot(t, y)
end

function [c, ceq] = confun(x)
    % Nonlinear inequality constraints
    c = (x(1)-0.5)^2 + (x(2)-0.5)^2 - 0.5^2;
    % Nonlinear equality constraints
    ceq = [];
end

function [x, y]=RanCircleP(x1,y1,rc)
    a=2*pi*rand;
    r=sqrt(rand);
    x=(rc*r)*cos(a)+x1;
    y=(rc*r)*sin(a)+y1;
end

