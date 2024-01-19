classdef FB2223
    %FB2223 Car specs for the Formula Buckeyes FB-23

    properties
        wheelbase = 1.616;      % [m]
        trackwidthFront = 1.2;  % [m]
        trackwidthRear = 1.175; % [m]
        steerRatio = 3.5;
        FLShockZero = 19.19;    % [mm]
        FRShockZero = 23.62;    % [mm]
        RLShockZero = 38.76;    % [mm]
        RRShockZero = 35.94;    % [mm]
        FrontARBMotionRatio = 0.58;
        RearARBMotionRatio = 0.39;
        GearRatios = [4.2222, 3.5185, 3.0494, 2.7536, 2.5509];
        FinalDriveRatio = 3.273;
        TireRadius = 0.198;     % [m]
    end

    methods
        function obj = FB2223()
            %This constructor does nothing :)
        end
        function [obj] = setShockZeros(run)
            % Zero the shocks right when the car starts to roll
            zeroPos = find(run.GroundSpeed > 0, 1);
%             zeroPos = find(run.SteeredAngle <= 0.1 && ... 
%                 run.SteeredAngle >= -0.1 && ... 
%                 run.GroundSpeed < 1, 1);
            obj.FLShockZero = run.SuspPosFL(zeroPos);
            obj.FRShockZero = run.SuspPosFR(zeroPos);
            obj.RLShockZero = run.SuspPosRL(zeroPos);
            obj.RRShockZero = run.SuspPosRR(zeroPos);
        end

    end
end