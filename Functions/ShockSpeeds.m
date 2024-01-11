function [MaxShockSpeeds, MeanShockSpeeds, AbsShockSpeeds] = ShockSpeeds(run)
    % calculates derivative of suspension positon to get shock speeds
    % for Front Left, Front Right, Rear Left, Rear Right
    ShockSpeedFL = gradient(run.SuspPosFL, run.Time);
    ShockSpeedFR = gradient(run.SuspPosFR, run.Time);
    ShockSpeedRL = gradient(run.SuspPosRL, run.Time);
    ShockSpeedRR = gradient(run.SuspPosRR, run.Time);

    % gets absolute values (height(run) x 4)
    AbsShockSpeeds = abs([ShockSpeedFL ShockSpeedFR ShockSpeedRL ShockSpeedRR]);
    % gets maximum absolute values (height(run) x 1)
    MaxShockSpeeds = max(AbsShockSpeeds, [], 2);
    % gets mean absolute values (height(run) x 1)
    MeanShockSpeeds = mean(AbsShockSpeeds, 2);

    %% Plotting
    % plot(run.Time, AbsShockSpeeds(:,1), "k", run.Time, AbsShockSpeeds(:,2), "r", run.Time, AbsShockSpeeds(:,3), "g", run.Time, AbsShockSpeeds(:,4), "b");
    % plot(run.Time, AbsShockSpeeds);
end