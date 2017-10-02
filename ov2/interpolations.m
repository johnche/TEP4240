function [ linear,nearest,pchip,spline ] = interpolations( values, steps )
    linear = interp1(values(1,:), values(2,:), steps);
    nearest = interp1(values(1,:), values(2,:), steps, 'nearest');
    pchip = interp1(values(1,:), values(2,:), steps, 'pchip');
    spline = interp1(values(1,:), values(2,:), steps, 'spline');
end
