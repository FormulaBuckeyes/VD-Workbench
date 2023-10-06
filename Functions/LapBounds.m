function [start, stop] = LapBounds(run, lapZero, lapMax, currentLap)
%LapBounds Outputs the start and ending indicies for the current lap
start = find(run.LapNumber == lapZero + currentLap,1);
if lapZero+currentLap == lapMax
    [stop,~] = size(run.LapNumber);
else
    stop = find(run.LapNumber > lapZero + currentLap,1);
end
end