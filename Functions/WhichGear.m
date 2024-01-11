function [FinalData] = WhichGear(run)
% run.EngineRPM;
% run.DriveSpeed;
% run.Time;

%% STORING VARIABLES, probably not necessary, just did it for myself
EngineRPM = run.EngineRPM; % rotations/minutes
DriveSpeed = run.DriveSpeed * 1000 / 60; % km/h --> meters/minutes
Time = run.Time; % seconds

%% CONSTANTS
GEAR_RATIOS = [4.2222, 3.5185, 3.0494, 2.7536, 2.5509]
FINAL_DRIVE_RATIO = 3.273

TIRE_RADIUS = 0.198 % meters

COMBINED_RATIOS = FINAL_DRIVE_RATIO * GEAR_RATIOS; % Gear1 > Gear2 > Gear3 > Gear4 > Gear5

%% CALCULATIONS
WheelRPM = DriveSpeed/(2*pi*TIRE_RADIUS); % rotations/minutes, (meters/minutes) / (2*pi*r), r in meters

%% Calculate predicted combined ratios from data
% WheelRPM = EngineRPM / COMBINED_RATIO
% COMBINED_RATIO = EngineRPM / WheelRPM
PredictedCombinedRatios = EngineRPM ./ WheelRPM; % Values should match with values in COMBINED_RATIO

%% Finding Which Gear Car is in
WhichGear = zeros(length(GEAR_RATIOS), length(EngineRPM));

% Gear 1
WhichGear(1,:) = PredictedCombinedRatios >= mean(COMBINED_RATIOS(1:2));

% Gears 2-4
for i = 2:length(COMBINED_RATIOS)-1
    WhichGear(i,:) = (PredictedCombinedRatios < mean(COMBINED_RATIOS(i-1:i))) .* (PredictedCombinedRatios >= mean(COMBINED_RATIOS(i:i+1)));
end

% Gear 5
WhichGear(end,:) = PredictedCombinedRatios < mean(COMBINED_RATIOS(end-1:end));

%% Combining data
FinalData = WhichGear(1,:);
for i = 2:length(WhichGear(:,1))
    FinalData = FinalData + WhichGear(i,:)*i;
end

%% Plotting
plot(Time, FinalData);
title('Predicted Gear vs Time')
xlabel('Time (s)')
ylabel('Predicted Gear')

%% FinalData Format: FinalData = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 5, 5, 5, 5,...]
%% 1 = Gear1, 2 = Gear2, 3 = Gear3, 4 = Gear4, 5 = Gear5, length of run data
end