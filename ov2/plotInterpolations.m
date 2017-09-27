clc
clear all
close all

motor=[0, 400, 800, 1200, 1600, 1763;
       8, 8.5, 9.0, 9.90, 7.15,    0];

fan=[0, 400, 800, 1200;
     2, 3.8, 7.5,   14];

figure(1)
hold on
[ motorSpeeds,motorLinear,motorNearest,motorPchip,motorSpline ] = interpolations(motor);
plot(motor(1,:), motor(2,:), 'b+')
%plot(motorSteps, motorLinear, 'b-.')
%plot(motorSteps, motorNearest, 'b--')
%plot(motorSteps, motorPchip, 'b:')
plot(motorSpeeds, motorSpline, 'b-')
[ fanSpeeds,fanLinear,fanNearest,fanPchip,fanSpline ] = interpolations(fan);
plot(fan(1,:), fan(2,:), 'r+')
%plot(fanSteps, fanLinear, 'r-.')
%plot(fanSteps, fanNearest, 'r--')
%plot(fanSteps, fanPchip, 'r:')
plot(fanSpeeds, fanSpline, 'r-')
legend('motor',...'linear','nearest','pchip',
    'cubic','fan',...'linear','nearest','pchip',
    'cubic')
ylabel('torque, in.-lb')
xlabel('speed, rpm')
hold off