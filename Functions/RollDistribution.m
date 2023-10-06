function [distFront, distRear, distLeft, distRight, ratioFR, ratioLR] = ...
    RollDistribution(run, car)
%RollDistribution Suspension Roll Distribution Calculator
%   In: run, car | Out: frontDistribution, rearDistribution, ratio
%   Front/Rear | All distributions are L - R

% Negative values indicate compression
FLzeroed = run.SuspPosFL - car.FLShockZero;
FRzeroed = run.SuspPosFR - car.FRShockZero;
RLzeroed = run.SuspPosRL - car.RLShockZero;
RRzeroed = run.SuspPosRR - car.RRShockZero;

% dist. = distribution
distFront = FLzeroed - FRzeroed;
distRear = RLzeroed - RRzeroed;
distLeft = FLzeroed - RLzeroed;
distRight = FRzeroed - RRzeroed;

ratioFR = mean(distFront) / mean(distRear);
ratioLR = mean(distLeft) / mean(distRight);

end