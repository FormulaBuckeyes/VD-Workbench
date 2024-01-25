clc; clear; close all;
% Max comparisons: 8 - Limited by plot colors at the moment, theoretically
% can be infinite (don't do that tho)
% ***Use parsed .mat files via the Accel.m script!!!***
version = 2; % 1 for Time, 2 for Distance
numCompare = 3; % Number of runs to overlay

if version == 1
    for i = 1:numCompare
    [filename, path] = uigetfile('*.mat', 'Select Parsed Launch File');
    ff = fullfile(path,filename); load(ff);
    data = run;
        if i == 1
            AccelSetup(data);
            datum = data;
        else
            AccelOverlay(data,i);
            TimeDelta(datum, data,i);
        end
    end
end

if version == 2
    for i = 1:numCompare
    [filename, path] = uigetfile('*.mat', 'Select Parsed Launch File');
    ff = fullfile(path,filename); load(ff);
    data = run;
        if i == 1
            AccelSetupDist(data)
            datum = data;
        else
            AccelOverlayDist(data,i)
            TimeDelta(datum, data,i);
        end
    end
end

