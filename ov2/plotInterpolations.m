clc
clear all
close all

motor=[0, 400, 800, 1200, 1600, 1763;
       8, 8.5, 9.0, 9.90, 7.15,    0];

fan=[0, 400, 800, 1200;
     2, 3.8, 7.5,   14];

figure(1)

ylabel('torque, in.-lb')
xlabel('speed, rpm')
hold on

stepcount = 1000;
speeds = linspace(motor(1), motor(1, end), stepcount);
[ motorLinear,motorNearest,motorPchip,motorSpline ] = interpolations(motor, speeds);
[ fanLinear,fanNearest,fanPchip,fanSpline ] = interpolations(fan, speeds);

[maxPower,maxPower_motorIndex] = max(speeds.*motorSpline.*(motorSpline <= 4));
[~,maxPower_fanIndex] = min(abs(speeds.*fanSpline-maxPower));
maxPower_motorTorque = motorSpline(maxPower_motorIndex);
maxPower_motorSpeed = speeds(maxPower_motorIndex);
maxPower_fanTorque = fanSpline(maxPower_fanIndex);
maxPower_fanSpeed = speeds(maxPower_fanIndex);
beltRatio = maxPower_motorSpeed/maxPower_fanSpeed;

plot(motor(1,:), motor(2,:), 'b+')
%plot(motorSteps, motorLinear, 'b-.')
%plot(motorSteps, motorNearest, 'b--')
%plot(motorSteps, motorPchip, 'b:')
plot(speeds, motorSpline, 'b-')
plot(speeds(maxPower_motorIndex), motorSpline(maxPower_motorIndex), 'bd')

plot(fan(1,:), fan(2,:), 'r+')
%plot(fanSteps, fanLinear, 'r-.')
%plot(fanSteps, fanNearest, 'r--')
%plot(fanSteps, fanPchip, 'r:')
plot(speeds, fanSpline, 'r-')
plot(maxPower_fanSpeed, maxPower_fanTorque, 'rd')

legend('motor real',...'linear','nearest','pchip',
    'motor interpolated','motor max power', 'fan real',...'linear','nearest','pchip',
    'fan interpolated','fan max power',...
    'Location', 'northwest')
hold off