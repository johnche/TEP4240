clear all
close all
clc
%% Bond Graphs
img = imread('1_d.jpg');
img2 = imread('2_a.jpg');
img3 = imread('3_b.png');
img4 = imread('4_a.jpg');
figure, imshow(img);
figure, imshow(img2);
figure, imshow(img3);
figure, imshow(img4);

%% Simulation

g = -10;
m = 2;
k = 2;
R = 1;

I = m;
c = 1/k;
q_0 = 0;
p_0 = 0;

x_0 = [q_0 ; p_0];
dx_dt = @(t, x) [x(2)/I ; m*g - x(1)/c - R*x(2)/I];
[t, x] = ode45(dx_dt, 1:.01:200, x_0);

plot(t, x)
legend('p', 'q')