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
beltRatio = maxPower_motorTorque/maxPower_fanTorque;

fprintf('a)\n')
fprintf('  S --> T --> R\n')

fprintf('b)\n')
fprintf('  max power = %f\n', maxPower)
fprintf('  motor speed at max power = %f\n', maxPower_motorSpeed)

fprintf('c)\n')
fprintf('  T = %f\n', beltRatio)
fprintf('  fan speed at max power = %f\n', maxPower_fanSpeed)
fprintf('  fan torque at max power = %f\n', maxPower_fanTorque)

figure(1)
ylabel('torque, in.-lb')
xlabel('speed, rpm')
axis([speeds(1) speeds(1, end), min(motorSpline) max(motorSpline)*1.4])
hold on

plot(motor(1,:), motor(2,:), 'b+')
plot(speeds, motorSpline, 'b-')
plot(speeds(maxPower_motorIndex), motorSpline(maxPower_motorIndex), 'bd')

plot(fan(1,:), fan(2,:), 'r+')
plot(speeds, fanSpline, 'r-')
plot(maxPower_fanSpeed, maxPower_fanTorque, 'rd')
plot(speeds/beltRatio, fanSpline*beltRatio, 'r-.')

plot(speeds, maxPower./speeds)

legend('motor real',...'linear','nearest','pchip',
    'motor interpolated','motor max power', 'fan real',...'linear','nearest','pchip',
    'fan interpolated','fan max power','fan transformed',...
    'Location', 'northwest')
hold off