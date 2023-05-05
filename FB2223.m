classdef FB2223
    %FB2223 Car specs for the Formula Buckeyes FB-23

    properties
        wheelbase = 1.616;
        steerRatio = 3.5;
        FLShockZero = 19.19;
        FRShockZero = 23.62;
        RLShockZero = 38.76;
        RRShockZero = 35.94;
%         rollRate = ;
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