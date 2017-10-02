clc
clear all
close all

motor=[0, 400, 800, 1200, 1600, 1763;
       8, 8.5, 9.0, 9.90, 7.15,    0];

fan=[0, 400, 800, 1200;
     2, 3.8, 7.5,   14];


stepcount = 1000;
speeds = linspace(motor(1), motor(1, end), stepcount);
motorSpline = interp1(motor(1,:), motor(2,:), speeds, 'spline');
fanSpline = interp1(fan(1,:), fan(2,:), speeds, 'spline');

[maxPower,maxPower_motorIndex] = max(speeds.*motorSpline.*(motorSpline <= 4));
[~,maxPower_fanIndex] = min(abs(speeds.*fanSpline-maxPower));
maxPower_motorTorque = motorSpline(maxPower_motorIndex);
maxPower_motorSpeed = speeds(maxPower_motorIndex);
maxPower_fanTorque = fanSpline(maxPower_fanIndex);
maxPower_fanSpeed = speeds(maxPower_fanIndex);
beltRatio = maxPower_motorSpeed/maxPower_fanSpeed;

disp('a)')
disp('  S --> R')

fprintf('b)\n')
fprintf('  maxPower_motorSpeed = %f\n', maxPower_motorSpeed)
fprintf('  maxPower = %f\n', maxPower)

fprintf('c)\n')
fprintf('  maxPower_fanSpeed = %f\n', maxPower_fanSpeed)
fprintf('  maxPower_fanTorque = %f\n', maxPower_fanTorque)
fprintf('  beltRatio = %f\n', beltRatio)

figure(1)

ylabel('torque, in.-lb')
xlabel('speed, rpm')
hold on

plot(motor(1,:), motor(2,:), 'b+')
plot(speeds, motorSpline, 'b-')
plot(speeds(maxPower_motorIndex), motorSpline(maxPower_motorIndex), 'bd')

plot(fan(1,:), fan(2,:), 'r+')
plot(speeds, fanSpline, 'r-')
plot(maxPower_fanSpeed, maxPower_fanTorque, 'rd')

legend('motor real',...'linear','nearest','pchip',
    'motor interpolated','motor max power', 'fan real',...'linear','nearest','pchip',
    'fan interpolated','fan max power',...
    'Location', 'northwest')
hold off