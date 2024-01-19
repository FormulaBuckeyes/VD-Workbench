%% Event Name
clf; close all;
addpath("../Functions/");
[filename, path] = uigetfile('*.csv', 'Select MoTeC Output File (.csv)');
data = motecImport(filename,path);
metadata = motecMetadata(filename);
totalDistance = max(data.Distance);
totalTime = max(data.Time);

[lapData, lapTimes] = parseEventRuns(data);

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

summaryTable = table((1:length(size(lapData)))',lapTimes', ...
    'VariableNames',["Lap #" "Lap Time"]);
disp(summaryTable)

fprintf("Average gLat: %f\n", mean(data.GForceLatC185(1:end-1)))

%%
for k=1:length(lapTimes)
    runID = strcat('r',num2str(k));
    n = int64(0.25/(data.Time(2)-data.Time(1))); % 0.25 second window size 
%% Suspension
suspensionEventPlot(lapData.(runID),n,lapTimes(k))

end

%%
outputFilename = sprintf("%sEvent%s_%s.pdf", ...
    "../Logs/", ...
    strrep(metadata.logDate,"/","-"), ...
    strrep(sprintf("%.2f",min(lapTimes)),".","-"));

%%

function [runs, times] = parseEventRuns(data)
% Find all the laps (given by beacons) with an absolute value latG > 1,
% then exoprt those as the laps. Therefore "laps" are turns. 



end

function suspensionEventPlot(data, lapTime, smoothfactor)

end