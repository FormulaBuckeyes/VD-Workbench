function [throttleAcceptance, gLatMax, gLatThrottle] = ThrottleAcceptance(run, gLat)
% ThrottleAcceptance Returns the throttle acceptance percentages for each 
% full throttle during a run. 

openThrottles = [1 find(run.ThrottlePos > 99)' ];

% filter for only the first points the car reaches full throttle
openThrottles = openThrottles(diff(openThrottles) ~= 1); 

% preallocate space 
gLatMax = zeros(1,length(openThrottles)-1); 
gLatThrottle = zeros(1,length(openThrottles)-1); 

for i = 1:length(openThrottles)-1
    gLatSubset = gLat(openThrottles(i):openThrottles(i+1));
    gLatMax(i) = max(abs(gLatSubset));
    gLatThrottle(i) = abs(gLat(openThrottles(i+1)));
end

throttleAcceptance = 100 * (gLatThrottle ./ gLatMax);

% Logic: Search between each time the driver goes full
% throttle for the maximum gLat in that section, then compare it to the
% gLat during the first time the car reaches 100% throttle coming out 
% of the section. 

end
