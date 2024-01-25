%% Skidpad Report
clf; close all;
addpath("../Functions/");
[filename, path] = uigetfile('*.csv', 'Select MoTeC Output File (.csv)');
data = motecImport(filename,path);
metadata = motecMetadata(filename);
totalDistance = max(data.Distance);
totalTime = max(data.Time);

[lapData, lapTimes, avgLatGs, yawRates] = parseSkidpadRuns(data);

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
    avgLatGs', yawRates', ...
    'VariableNames',["Lap #" "Lap Time" "Avg LatG" "Avg Yaw Rate"]);
disp(summaryTable)

fprintf("Average gLat: %f\n", mean(data.GForceLatC185(1:end-1)))

%%
for k=1:length(lapTimes)
    runID = strcat('r',num2str(k));
    n = int64(0.25/(data.Time(2)-data.Time(1))); % 0.25 second window size 
%% Suspension
suspensionSkidpadPlot(lapData.(runID),lapTimes(k),car,n)

end

%%
outputFilename = sprintf("%sSkidpad%s_%s.pdf", ...
    "../Logs/", ...
    strrep(metadata.logDate,"/","-"), ...
    strrep(sprintf("%.2f",min(lapTimes)),".","-"));

%%

function [runs, times, avgLatGs, yawRates] = parseSkidpadRuns(data)
% parseSkidpadRuns Finds all of the individual skidpad turns (sub-laps) for
% a given dataset.
% Input: data is the csv for the entire log
% Outputs: runs is a struct with log subsets, times is a vector of lap
% times, avgLatGs is the average Lat G for each lap, yawRates is the
% average yaw rates for each lap

    lapZero = min(data.LapNumber)-1;
    lapMax = max(data.LapNumber);
    laps = 1 : lapMax-lapZero+1;
    times = zeros(size(laps));
    avgLatGs = zeros(size(laps));
    yawRates = zeros(size(laps));
    runs = struct;
    
    % Filtering for only skidpad laps
    latThreshold = .5; % average latG through lap to test for skidpad
    smoothFactor = int64(0.25/(data.Time(2)-data.Time(1))); % .25 second window size
    smoothedGLat = smoothdata(data.GForceLatC185,'gaussian',smoothFactor);
    
    lapNumber = 1;
    for i = laps
        [start, stop] = LapBounds(data, lapZero, lapMax, i);
        if abs(mean(data.GForceLatC185(start:stop))) >= latThreshold
            lapID = strcat('r',num2str(lapNumber));
            runs.(lapID) = data(start:stop,:);
            times(lapNumber) = data.Time(stop)-data.Time(start);
            avgLatGs(lapNumber) = mean(data.GForceLatC185(start:stop));
            yawRates(lapNumber) = mean(data.GyroYawVelocityIMU(start:stop));
            lapNumber = lapNumber + 1;
        end
    end
    
    times = times(1:find(times>0,1,"last"));
    avgLatGs = avgLatGs(1:find(times>0,1,"last"));
    yawRates = yawRates(1:find(times>0,1,"last"));

end

function suspensionSkidpadPlot(data, lapTime, car, smoothfactor)
% Outputs: 
%   Roll Distribution vs LatG
%   Understeer Gradient

% Roll Distribution vs Lateral G
bumpFiltered = data(abs(data.GForceVertC185) < .21,:); % .21 is arbitrary
[distrFront, distrRear, ~, ~, ratioFR, ~] = ...
    RollDistribution(bumpFiltered, car);

figure
tiledlayout(2,1)
nexttile
plot(bumpFiltered.GForceLatC185,distrFront,"rx",...
    bumpFiltered.GForceLatC185,distrRear,"b+")
title(sprintf("Roll Distributions vs Lateral G - %f",lapTime))
legend("Front Roll Distr.","Rear Roll Distr.")
nexttile
plot(bumpFiltered.GForceLatC185,distrFront ./ distrRear,"kx")
yline(ratioFR,"b-")
legend("FR Ratio", sprintf("Avg: %f",ratioFR))

% Understeer Gradient
[underAngle,ackerAngle,wheelAngle] = UndersteerAngle( ...
    data.GForceLatC185, data.GPSSpeed, data.SteeredAngle, car);

figure
plot(data.Time,underAngle,'b-')
yline(0,'k-')
yline(mean(underAngle),'r-')
legend('Understeer Angle', '0', sprintf('Average: %f', mean(underAngle)))
title(sprintf("Understeer Gradient - %f",lapTime))

end
