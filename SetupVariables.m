function [gLat, gLong, speed, time] = SetupVariables(run, gtype, speedtype)
%SetupVariables Output consistent gLat, gLong, Speed, Time variables

if gtype == "IMU"
    gLat = run.VehicleAccelLateralIMU;
    gLong = run.VehicleAccelLongIMU;
else % C185
    gLat = lapTrimRun.GForceLatC185;
    gLong = lapTrimRun.GForceLongC185;
end

if speedtype == "GroundSpeed"
    speed = run.GroundSpeed;
elseif speedtype == "DriveSpeed"
    speed = run.DriveSpeed;
else % GPS
    speed = run.GPSSpeed;
end

time = run.Time;

end