%% Skidpad Report
clf; close all;
addpath("../Functions/");
[filename, path] = uigetfile('*.csv', 'Select MoTeC Output File (.csv)');
data = motecImport(filename,path);
metadata = motecMetadata(filename);
totalDistance = max(data.Distance);
totalTime = max(data.Time);

[lapData, lapTimes] = parseSkidpadRuns(data);

car = FB2223();

%% Summary

fprintf("Track: %s\n", metadata.track)
fprintf("Driver: %s\n", metadata.driver)
fprintf("Run Date: %s\n", metadata.logDate)
fprintf("Run Time: %s\n", metadata.logTime)
fprintf("Session Distance: %d m\n", totalDistance)
fprintf("Session Length: %d s\n", totalTime)
fprintf("Comments: %s\n", metadata.comment)
fprintf("Report Generated: %s\n", datetime("now"))

summaryTable = table((1:length(fieldnames(lapData)))',lapTimes', ...
    'VariableNames',["Lap #" "Lap Time"]);
disp(summaryTable)

% Other things for the table: latG (max or avg), yaw rate

fprintf("Average gLat: %f\n", mean(data.GForceLatC185(1:end-1)))

%%
for k=1:length(lapTimes)
    runID = strcat('r',num2str(k));
    n = int64(0.25/(data.Time(2)-data.Time(1))); % 0.25 second window size 
%% Suspension
suspensionSkidpadPlot(lapData.(runID),n,lapTimes(k))

end

%%
outputFilename = sprintf("%sSkidpad%s_%s.pdf", ...
    "../Logs/", ...
    strrep(metadata.logDate,"/","-"), ...
    strrep(sprintf("%.2f",min(lapTimes)),".","-"));

%%

function [runs, times] = parseSkidpadRuns(data)
% parseSkidpadRuns Finds all of the individual skidpad turns (sub-laps) for
% a given dataset.
% Runs is a struct, times is a vector

    lapZero = min(data.LapNumber)-1;
    lapMax = max(data.LapNumber);
    laps = 1 : lapMax-lapZero+1;
    times = zeros(size(laps));
    runs = struct;
    
    % Filtering for only skidpad laps
    latThreshold = .5; % average latG through lap to test for skidpad
    smoothFactor = int64(0.25/(data.Time(2)-data.Time(1))); % .25 second window size
    smoothedGLat = smoothdata(data.GForceLatC185,'gaussian',smoothFactor);
    
    lapNumber = 1;
    for i = laps
        [start, stop] = LapBounds(data, lapZero, lapMax, i);
        if abs(mean(smoothedGLat(start:stop))) >= latThreshold
            lapID = strcat('r',num2str(lapNumber));
            runs.(lapID) = data(start:stop,:);
            times(lapNumber) = data.Time(stop)-data.Time(start);
            lapNumber = lapNumber + 1;
        end
    end
    
    times = times(1:find(times>0,1,"last"));

end

function suspensionSkidpadPlot(data, lapTime, smoothfactor)

end