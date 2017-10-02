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
steps = linspace(motor(1), motor(1, end), stepcount);
[ motorLinear,motorNearest,motorPchip,motorSpline ] = interpolations(motor, steps);
plot(motor(1,:), motor(2,:), 'b+')
%plot(motorSteps, motorLinear, 'b-.')
%plot(motorSteps, motorNearest, 'b--')
%plot(motorSteps, motorPchip, 'b:')
plot(steps, motorSpline, 'b-')
plot(steps, 4.*ones(stepcount))

intersectionStep = 1;
minIntersectionDiff = 99999;
for k = 1:stepcount
    difference = abs(motorSpline(k) - 4);
    if difference < minIntersectionDiff
        minIntersectionDiff = difference;
        intersectionStep = k;
    end
end
maxPower_RPM = steps(intersectionStep)
plot(steps(intersectionStep), 4, 'X')
[ fanLinear,fanNearest,fanPchip,fanSpline ] = interpolations(fan, steps);
plot(fan(1,:), fan(2,:), 'r+')
%plot(fanSteps, fanLinear, 'r-.')
%plot(fanSteps, fanNearest, 'r--')
%plot(fanSteps, fanPchip, 'r:')
plot(steps, fanSpline, 'r-')
maxPower_fanTorque = fanSpline(intersectionStep)
plot(steps(intersectionStep), maxPower_fanTorque, 'X')
legend('motor real',...'linear','nearest','pchip',
    'motor interpolated','motor max power', 'fan real',...'linear','nearest','pchip',
    'fan interpolated','Location', 'northwest')
hold off