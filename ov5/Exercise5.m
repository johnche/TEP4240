%% Problem 1: Finding the tallest point on an island

z = @(x) -sin(4*pi*x(1))*sin(5*pi*x(2))*(2 - x(1))*(2 - x(2)); %x in km
options = optimoptions('fmincon', 'Display', 'off');

% set z to negtive in order to use fmincon

%Quadratic (x_1 and x_2 from 0 to 1):

testnormal = [0:0.01:1;0:0.01:1];
testfmincon = [0.1, 0.1];
xlength = length(testnormal);
xmax = -100;
lb = zeros(size(testfmincon));
up = ones(size(testfmincon));
[x, fval] = fmincon(z, testfmincon, [], [], [], [], lb, up, [], options);
fvalues = zeros(1, xlength);
for q=1:xlength
    xin = [testnormal(1, q), testnormal(2, q)];
    [x, fvalu] = fmincon(z, xin, [], [], [], [], lb, up, [], options);
    fvalues(q) = fvalu;
end

for i=1:xlength
    for k = 1:xlength
        x_1 = testnormal(1, i);
        x_2 = testnormal(2, k);
        zpoint = -z([x_1, x_2]);
        if(xmax < zpoint)
           xmax = zpoint;
        end
    end
end
fprintf('The highest peak is %f kms (fmincon with different start values)\n', -min(fvalues));
fprintf('The highest peak is %f kms (fmincon)\n', -fval);
fprintf('The highest peak is %f kms (Something else)\n', xmax);

%Circular (origo in x1 = x2 = 0.5 km and radius = 0.5 km): 



%% Problem 2: Find the optimal values for R and C.
