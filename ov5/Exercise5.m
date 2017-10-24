%% Problem 1: Finding the tallest point on an island

z = @(x) -sin(4*pi*x(1))*sin(5*pi*x(2))*(2 - x(1))*(2 - x(2)); %x in km
% set z to negtive in order to use fmincon

options = optimoptions('fmincon','Display', 'off');
%Quadratic (x_1 and x_2 from 0 to 1):

% testnormal = [0:0.1:1;0:0.1:1];
% testfmincon = [0.1, 0.1];
% xlength = length(testnormal);
% xmax = -100;
% lb = zeros(size(testfmincon));
% up = ones(size(testfmincon));
% [x, fval] = fmincon(z, testfmincon, [], [], [], [], lb, up);
% fvalues = zeros(1, xlength);
% for q=1:xlength
%     xin = [testnormal(1, q), testnormal(2, q)];
%     [x, fvalu] = fmincon(z, xin, [], [], [], [], lb, up, [], options);
%     fvalues(q) = fvalu;
% end
% 
% for i=1:xlength
%     for k = 1:xlength
%         x_1 = testnormal(1, i);
%         x_2 = testnormal(2, k);
%         zpoint = -z([x_1, x_2]);
%         if(xmax < zpoint)
%            xmax = zpoint;
%         end
%     end
% end
% fprintf('The highest peak is %f kms (fmincon with different start values)\n', -min(fvalues));
% fprintf('The highest peak is %f kms (fmincon)\n', -fval);
% fprintf('The highest peak is %f kms (Something else)\n', xmax);

%%Circular (origo in x1 = x2 = 0.5 km and radius = 0.5 km): 

%to test the function

%circlepts = [0:0.05:1; 0:0.05:1];
tfminconcircle = [0.1, 0.1];
%xlength = length(circlepts);
xmaxcircle = 0;
[xvalcircle, fvalcircle] = fmincon(z, tfminconcircle, [], [], [], [], [], [], @confun);
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

%%Circular Constraints function

fprintf('The highest peak is %f kms on point (%f, %f)(fmincon with different start values)\n',... 
                -xmaxcircle, x_1maxpoint, x_2maxpoint);
fprintf('The highest peak is %f kms on point %f (fmincon startpoint (0.1, 0.1)\n',...
    -fvalcircle, xvalcircle);

function [c, ceq] = confun(x)
% Nonlinear inequality constraints
c = (x(1)-0.5)^2 + (x(2)-0.5)^2 - 0.5^2;
% Nonlinear equality constraints
ceq = [];
end

function [x, y]=RanCircleP(x1,y1,rc)
%the function, must be on a folder in matlab path
a=2*pi*rand;
r=sqrt(rand);
x=(rc*r)*cos(a)+x1;
y=(rc*r)*sin(a)+y1;
end

%% Problem 2: Find the optimal values for R and C.

