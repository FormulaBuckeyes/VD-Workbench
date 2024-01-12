%% Event Name
clf; close all;
[filename, path] = uigetfile('*.csv', 'Select MoTeC Output File (.csv)');
data = motecImport(filename,pwd);
metadata = motecMetadata(filename);
totalDistance = max(data.Distance);
totalTime = max(data.Time);

% Replace Event with actual event in real code
% Replace Subteam with actual subteam in real code
lapData = parseEventRuns(data); % Need to make this a real thing
lapTimes = eventLapTimes(lapData); % Need to make this a real thing

%% Summary

fprintf("Track: %s", metadata.track)
fprintf("Driver: %s", metadata.driver)
fprintf("Run Date: %s", metadata.logDate)
fprintf("Run Time: %s", metadata.logTime)
fprintf("Session Distance: %d", totalDistance)
fprintf("Session Length: %d", totalTime)
fprintf("Comments: %s", metadata.comment)
fprintf("Report Generated: %s", datetime("now"))

% lap times

% left vs right (average of gLat for all lapData - should be 0)
% (could be moved to suspension)

%% Subteam

subteamEventPlot(lapData)

% This function should make plot(s)
% One function per subteam would make formatting very nice
% There can't be any comments in this script for formatting reasons
% so do all of it inside the function.

%% Subteam

% new plot

%%
% This has not been tested yet but should make a pdf, then 
% rename and move it
% Need a better naming convention for the file
% outputFilename = sprintf("./Logs/Event%s.pdf","1");
% publish("EventSummaryTemplate.m","format","pdf", showCode=false)
% movefile "EventSummaryTemplate.pdf" outputFilename