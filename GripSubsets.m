function [gripOverall,gripBraking,gripAccel,gripCornering,gripAero] = GripSubsets(gLat,gLong,speed)
%GRIPSUBSETS Grip subsets for tire performance over time analysis
%   Set the boundaries manually inside the function

overallBound = 1;
GOindex = sqrt(gLat .^ 2 + gLong .^ 2) > overallBound;
gripOverall = sqrt(gLat(GOindex) .^ 2 + gLong(GOindex) .^ 2);

brakingBound = -1;
GBindex = gLong < brakingBound;
gripBraking = gLong(GBindex,:);

accelBound = 1;
GAindex = gLong > accelBound;
gripAccel = gLong(GAindex);

corneringBound = .5;
GCindex = abs(gLat) > corneringBound;
gripCornering = abs(gLat(GCindex,:));

aeroGBound = 1;
aeroSpeedBound = 10; % m/s
GAindex = gLong > aeroGBound & speed > aeroSpeedBound;
gripAero = gLong(GAindex,:);

end

