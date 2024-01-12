%% Event Name
clf; close all;
[filename, path] = uigetfile('*.csv', 'Select MoTeC Output File (.csv)');
data = motecImport(filename,pwd);
metadata = motecMetadata(filename);
totalDistance = max(data.Distance);
totalTime = max(data.Time);


%% Summary

fprintf("Track: %s", metadata.track)
fprintf("Driver: %s", metadata.driver)
fprintf("Run Date: %s", metadata.logDate)
fprintf("Run Time: %s", metadata.logTime)
fprintf("Comments: %s", metadata.comment)
fprintf("Report Generated: %s", datetime("now"))

% left vs right
% lap times


%% Subteam

% new plot

%% Subteam

% new plot

%%
% outputFilename = "./Logs/Event[Runtime].pdf";
% publish("EventSummaryTemplate.m","format","pdf", showCode=false)
% movefile "EventSummaryTemplate.pdf" "Logs"