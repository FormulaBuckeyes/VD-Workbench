function [distrFront, distrRear, distrLeft, distrRight, ratioFR, ratioLR] = ...
    RollDistribution(run, car)
%RollDistribution Suspension Roll Distribution Calculator
%   In: run, car | Out: frontDistribution, rearDistribution, ratio
%   Front/Rear | All distributions are L - R

% Negative values indicate compression
FLzeroed = run.SuspPosFL - car.FLShockZero;
FRzeroed = run.SuspPosFR - car.FRShockZero;
RLzeroed = run.SuspPosRL - car.RLShockZero;
RRzeroed = run.SuspPosRR - car.RRShockZero;

% distr. = distribution
distrFront = FLzeroed - FRzeroed;
distrRear = RLzeroed - RRzeroed;
distrLeft = FLzeroed - RLzeroed;
distrRight = FRzeroed - RRzeroed;

ratioFR = mean(distrFront) / mean(distrRear);
ratioLR = mean(distrLeft) / mean(distrRight);

end