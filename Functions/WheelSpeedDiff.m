function [RearSpeedDiff, FrontSpeedDiff, YRTW] = WheelSpeedDiff(run, car)
%WHEELSPEEDDIFF Finds actual and hypothetical wheel speed differences
%   YRTW is the Yaw Rate * Track Width which is the hypothetical optimal
%   wheel speed difference for the rear axle. 

YawRate = run.GyroYawVelocityIMU*pi/180; % [rad/s]
TW = car.trackwidthRear; % [m]
YRTW = YawRate*TW*3.6; %[km/h] + = right, - = left
RearSpeedL = run.DriveSpeedLeft; 
RearSpeedR = run.DriveSpeedRight;
RearSpeedDiff = RearSpeedL-RearSpeedR; 
FrontSpeedDiff = run.GroundSpeedLeft-run.GroundSpeedRight;

end

