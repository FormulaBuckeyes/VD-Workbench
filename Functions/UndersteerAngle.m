function [underAngle,ackerAngle,wheelAngle] = UndersteerAngle(gLat, speed, steerAngle, car)
%UndersteerAngle Finds the understeer, Ackermann, and wheel angles
% gLat in G, speed in kmh; output in degrees

accelLat = -gLat .* 9.80665; % convert from g to m/s^2
speed = speed * 0.277778; % convert from kmh to m/s

cornerRadius = (speed .^ 2) ./ accelLat;
ackerAngle = car.wheelbase ./ cornerRadius .* (360/(2*pi)); % convert to deg

% Understeer Angle
wheelAngle = steerAngle / car.steerRatio; % 3.5 
underAngle = abs(wheelAngle) - abs(ackerAngle);

end