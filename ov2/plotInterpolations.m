clc
clear all
close all

motor=[0, 400, 800, 1200, 1600, 1763;
       8, 8.5, 9.0, 9.90, 7.15,    0];

fan=[0, 400, 800, 1200;
     2, 3.8, 7.5,   14];


stepcount = 1000;
speeds = linspace(motor(1), motor(1, end), stepcount);
motorSpline = interp1(motor(1,:), motor(2,:), speeds, 'pchip');
fanSpline = interp1(fan(1,:), fan(2,:), speeds, 'pchip');

[maxPower,maxPower_motorIndex] = max(speeds.*motorSpline.*(motorSpline <= 4));
[~,maxPower_fanIndex] = min(abs(speeds.*fanSpline-maxPower));
maxPower_motorTorque = motorSpline(maxPower_motorIndex);
maxPower_motorSpeed = speeds(maxPower_motorIndex);
maxPower_fanTorque = fanSpline(maxPower_fanIndex);
maxPower_fanSpeed = speeds(maxPower_fanIndex);
beltRatio = maxPower_motorTorque/maxPower_fanTorque;

fprintf('a)\n')
fprintf('  S --> T --> L\n')

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

%d)
img = imread('bondgraph_XD.jpg');
image(img);

%e)
tmax=30;
dt=.1;                                        
k=0;
teta_dot=0;
tvec = 0:dt:tmax;
teta_dots_rpm = zeros(1, length(tvec));
Im = 0.2;
Iv = 1.2;
T = beltRatio;
for t= tvec
    teta_rpm = teta_dot*60/(2*pi);
    motorTorque = interp1(speeds, motorSpline, teta_rpm);
    fanTorque = interp1(speeds/beltRatio, fanSpline*beltRatio, teta_rpm);
    power_dot = motorTorque - fanTorque;
    teta_ddot = power_dot/(Im + T^2*Iv);
    teta_dot = teta_dot + dt*teta_ddot; %Euler
    k=k+1;
    teta_dots_rpm(k) = teta_rpm;
end

figure(2)
clf
hold on 
title('Start-up time to Steady state')
ylabel('(d/dt)\phi_{motor} [rpm]')
xlabel('Time [seconds]')
plot(tvec, teta_dots_rpm)
line([0 max(tvec)],[maxPower_motorSpeed maxPower_motorSpeed],'LineStyle',':')
line([0 max(tvec)],[maxPower_motorSpeed/2 maxPower_motorSpeed/2],'LineStyle',':')
text(5,maxPower_motorSpeed,'Steady state speed','VerticalAlignment','bottom')
text(5,maxPower_motorSpeed/2,'Half of steady_state speed','VerticalAlignment','bottom')
time_half_rpm=interp1(teta_dots_rpm, tvec, maxPower_motorSpeed/2);
line([time_half_rpm time_half_rpm],[0 maxPower_motorSpeed/2],'LineStyle','-.')
text(time_half_rpm, maxPower_motorSpeed/4,['\leftarrow Time to reach half of steady state speed = '...
      num2str(time_half_rpm) 'seconds'],'Fontweight','bold')