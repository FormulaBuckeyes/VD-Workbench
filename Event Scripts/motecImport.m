function moRun = motecImport(filename,path)
warning('off','MATLAB:table:ModifiedAndSavedVarnames')

dataLines = [19, Inf];
fullfilename = fullfile(path,filename);
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 120);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
% opts.VariableNames = ["Time", "Distance", "EngineRPM", "ThrottlePos", "ManifoldPres", "EngineTemp", "Lambda1", "GForceLatC185", "GForceLongC185", "ECUTemp", "GForceVertC185", "GroundSpeed", "LapDistance", "FuelCutLevelTotal", "IgnCutLevelTotal", "FuelInjDuty", "IgnAdvance", "LapTime", "LapGain_LossRunning", "LapNumber", "RunningLapTime", "TripDistance", "LapTimePredicted", "ReferenceLapTime", "DriveSpeed", "CPUUsage", "DeviceUpTime", "EngOilPres", "FuelPres", "EngOilTemp", "BatteryVolts", "BatVoltsC185", "C185Temp", "SteeredAngle", "Gear", "DriveSpeedLeft", "DriveSpeedRight", "GroundSpeedLeft", "GroundSpeedRight", "WheelSlip", "TCAimSlip", "LaunchAimRPM", "WheelSlipPercent", "BrakePressureFront", "BrakePressureRear", "IsBraking", "IsThrotle", "TrackFront", "GPSSatsUsed", "GPSAltitude", "GPSLatitude", "GPSLongitude", "GPSHeading", "GPSTime", "GPSDate", "GPSSpeed", "GyroRollVelocityIMU", "GyroPitchVelocityIMU", "GyroYawVelocityIMU", "FastestLapTime", "BrakeTempRL", "BrakeTempRR", "FLRotorTemp1", "FLRotorTemp2", "FLRotorTemp3", "FLRotorTemp4", "RLRotorTemp1", "RLRotorTemp2", "RLRotorTemp3", "RLRotorTemp4", "FRRotorTemp1", "FRRotorTemp2", "FRRotorTemp3", "FRRotorTemp4", "RRRotorTemp1", "RRRotorTemp2", "RRRotorTemp3", "RRRotorTemp4", "BatteryCurrent", "ExhaustTemp1", "ExhaustTemp2", "ExhaustTemp3", "ExhaustTemp4", "SuspPosFL", "SuspPosFR", "SuspPosRL", "SuspPosRR", "PMUCURRENT", "ShiftingCurrent", "ShiftingCurrent1", "IgnitionCutCurrent", "RearHarnessCurrent", "DashCurrent", "FrontHarnessCurrent", "ECUInjectorLambdaCurrent", "IgnitionCoilCurrent", "FuelPumpCurrent", "WaterPumpCurrent", "RadiatorFanCurrent", "StarterRelayCurrent", "AlternatorCurrent", "PMUTEMPL", "PMUTEMPR", "GearUpShiftTime", "Upshfting", "Downshifting", "ClutchActuating", "ClutchActuationTime", "DownshiftDelay", "GearDownShiftTime", "GearChangeCutTime", "IgnitionCutState", "VehicleAccelLateralIMU", "VehicleAccelLongIMU", "VehicleAccelVertIMU", "Downshift_Signal", "Neutral_Request", "NeutralSwitch", "Upshift_signal", "DataValidityStatusFlag"];
opts.VariableNamesLine = 15;
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
moRun = readtable(fullfilename, opts);

warning('on','MATLAB:table:ModifiedAndSavedVarnames')
end