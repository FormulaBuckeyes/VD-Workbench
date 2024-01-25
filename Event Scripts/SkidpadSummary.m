%% Skidpad Report
clf; close all;
addpath("../Functions/");
[filename, path] = uigetfile('*.csv', 'Select MoTeC Output File (.csv)');
data = motecImport(filename,path);
metadata = motecMetadata(filename);
totalDistance = max(data.Distance);
totalTime = max(data.Time);

[lapData, lapTimes, avgLatGs, yawRates] = parseSkidpadRuns(data);

car = FB2223();

%% Summary

fprintf("Track: %s\n", metadata.track)
fprintf("Driver: %s\n", metadata.driver)
fprintf("Run Date: %s\n", metadata.logDate)
fprintf("Run Time: %s\n", metadata.logTime)
fprintf("Session Distance: %d m\n", totalDistance)
fprintf("Session Length: %d s\n", totalTime)
fprintf("Comments: %s\n", metadata.comment)
fprintf("Report Generated: %s\n", datetime("now"))

summaryTable = table((1:length(fieldnames(lapData)))',lapTimes', ...
    avgLatGs', yawRates', ...
    'VariableNames',["Lap #" "Lap Time" "Avg LatG" "Avg Yaw Rate"]);
disp(summaryTable)

fprintf("Average gLat: %f\n", mean(data.GForceLatC185(1:end-1)))

%%
for k=1:length(lapTimes)
    runID = strcat('r',num2str(k));
    n = int64(0.25/(data.Time(2)-data.Time(1))); % 0.25 second window size 
    %% Suspension
    suspensionSkidpadPlot(lapData.(runID),lapTimes(k),car,n)
    %% Drivetrain
    drivetrainSkidpadPlot(lapData.(runID),lapTimes(k),car,n)
    %% Aerodynamics
    aeroSkidpadPlot(lapData.(runID),lapTimes(k),car,n)
end

%%
outputFilename = sprintf("%sSkidpad%s_%s.pdf", ...
    "../Logs/", ...
    strrep(metadata.logDate,"/","-"), ...
    strrep(sprintf("%.2f",min(lapTimes)),".","-"));

%%

function [runs, times, avgLatGs, yawRates] = parseSkidpadRuns(data)
% parseSkidpadRuns Finds all of the individual skidpad turns (sub-laps) for
% a given dataset.
% Input: data is the csv for the entire log
% Outputs: runs is a struct with log subsets, times is a vector of lap
% times, avgLatGs is the average Lat G for each lap, yawRates is the
% average yaw rates for each lap

    lapZero = min(data.LapNumber)-1;
    lapMax = max(data.LapNumber);
    laps = 1 : lapMax-lapZero+1;
    times = zeros(size(laps));
    avgLatGs = zeros(size(laps));
    yawRates = zeros(size(laps));
    runs = struct;
    
    % Filtering for only skidpad laps
    latThreshold = .5; % average latG through lap to test for skidpad
    smoothFactor = int64(0.25/(data.Time(2)-data.Time(1))); % .25 second window size
    smoothedGLat = smoothdata(data.GForceLatC185,'gaussian',smoothFactor);
    
    lapNumber = 1;
    for i = laps
        [start, stop] = LapBounds(data, lapZero, lapMax, i);
        if abs(mean(data.GForceLatC185(start:stop))) >= latThreshold
            lapID = strcat('r',num2str(lapNumber));
            runs.(lapID) = data(start:stop,:);
            times(lapNumber) = data.Time(stop)-data.Time(start);
            avgLatGs(lapNumber) = mean(data.GForceLatC185(start:stop));
            yawRates(lapNumber) = mean(data.GyroYawVelocityIMU(start:stop));
            lapNumber = lapNumber + 1;
        end
    end
    
    times = times(1:find(times>0,1,"last"));
    avgLatGs = avgLatGs(1:find(times>0,1,"last"));
    yawRates = yawRates(1:find(times>0,1,"last"));

end

function suspensionSkidpadPlot(data, lapTime, car, smoothFactor)
% Outputs: 
%   Roll Distribution vs LatG
%   Understeer Gradient

    % Roll Distribution vs Lateral G
    bumpFiltered = data(abs(data.GForceVertC185) < .21,:); % .21 is arbitrary
    [distrFront, distrRear, ~, ~, ratioFR, ~] = ...
        RollDistribution(bumpFiltered, car);
    
    figure
    tiledlayout(2,1)
    nexttile
    plot(bumpFiltered.GForceLatC185,distrFront,"rx",...
        bumpFiltered.GForceLatC185,distrRear,"b+")
    title(sprintf("Roll Distributions vs Lateral G - %f",lapTime))
    legend("Front Roll Distr.","Rear Roll Distr.")
    nexttile
    plot(bumpFiltered.GForceLatC185,distrFront ./ distrRear,"kx")
    yline(ratioFR,"b-")
    legend("FR Ratio", sprintf("Avg: %f",ratioFR))
    
    % Understeer Gradient
    [underAngle,ackerAngle,wheelAngle] = UndersteerAngle( ...
        data.GForceLatC185, data.GPSSpeed, data.SteeredAngle, car);
    
    figure
    tiledlayout(2,1)
    nexttile
    plot(data.GForceLatC185,wheelAngle,'bo')
    xlabel("Lateral Acceleration (g)")
    ylabel("Steered Angle (deg)")
    title(sprintf("Understeer Gradient - %f",lapTime))
    
    nexttile
    plot(data.Time,underAngle,'b-', ...
        data.Time,ackerAngle,'g-', ...
        data.Time,wheelAngle,'c-')
    yline(0,'k-')
    yline(mean(underAngle),'r-')
    legend('Understeer Angle', 'Ackermann Angle', 'Wheel Angle', '0', ...
        sprintf('Average UA: %f', mean(underAngle)))
    xlabel("Time (s)")
    ylabel("Angle (deg)")

end

function drivetrainSkidpadPlot(data, lapTime, car, smoothFactor)
% Outputs: 
%   Rear Wheel Speed Difference
%   Differential Locking % - vs time and vs throttle pos

    % Rear Wheel Speed Difference
    [RearSpeedDiff, FrontSpeedDiff, Optimal] = WheelSpeedDiff(data, car);
    time = data.Time;
    tiledlayout(3,1);
    ax1 = nexttile();
    plot(time,RearSpeedDiff,'k-'); hold on; grid on;
    plot(time,FrontSpeedDiff,'r-');
    plot(time,Optimal,'b--');
    legend("Rear", "Front", "Optimal")
    ylabel("Wheel Speed Diffs")
    title(sprintf("Wheel Speed Differences - %f",lapTime))
    ax2 = nexttile();
    plot(time,data.ThrottlePos); grid on;
    ylabel("Throttle Pos")
    ax3 = nexttile();
    plot(time,data.BrakePressureFront); grid on;
    ylabel("Brake Pressure")
    
    linkaxes([ax1, ax2, ax3],'x')
    
    % Diff Locking Percent
    %   Code
    %   Plot

end

function aeroSkidpadPlot(data, lapTime, car, smoothFactor)
    % Variables
    time = data.Time;
    SuspPosFL = data.SuspPosFL-data.SuspPosFL(1);
    SuspPosFR = data.SuspPosFR-data.SuspPosFR(1);
    SuspPosRL = data.SuspPosRL-data.SuspPosRL(1);
    SuspPosRR = data.SuspPosRR-data.SuspPosRR(1);
    SP_LF = smoothdata(SuspPosFL,'gaussian',smoothFactor);
    SP_RF = smoothdata(SuspPosFR,'gaussian',smoothFactor);
    SP_LR = smoothdata(SuspPosRL,'gaussian',smoothFactor);
    SP_RR = smoothdata(SuspPosRR,'gaussian',smoothFactor);
    MRF = 0.955; MRR = 0.99; % Motion Ratios [~]
    L = car.wheelbase * 1000; % [mm]
    
    % Heave & Pitch & Roll
    heave = SP_LF+SP_RF+SP_LR+SP_RR;
    pitch = atand(((SP_LF+SP_RF)*MRF/2-(SP_LR-SP_RR)*MRR/2)/L);
    rollFront = atand((SP_LF*MRF - SP_RF*MRF)/car.trackwidthFront);
    rollRear = atand((SP_LR*MRR - SP_RR*MRR)/car.trackwidthRear);
    
    figure;
    tiledlayout(4,1); sgtitle(sprintf('Heave, Pitch, Roll - %.3f [s]', lapTime));
    z = zoom;
    z.Motion = 'Horizontal';
    ax1 = nexttile;
    plot(time,data.GPSSpeed,'b-'); grid on; hold on;
    plot(time,data.DriveSpeed,'r-')
    setAxesZoomConstraint(z,ax1,'x');
    ylabel('Speed [mph]'); ylim([0 70]);
    legend('GPS Speed','Drive Speed','Location','southeast');

    ax2 = nexttile; grid on; hold on;
    plot(time,heave,'b-'); 
    ylabel('Heave [mm]'); ylim([-25 1])
    setAxesZoomConstraint(z,ax2,'x');

    ax3 = nexttile; grid on; hold on;
    plot(time,pitch,'b-');
    ylabel('Pitch [deg]'); ylim([-0.15 0.25]);
    setAxesZoomConstraint(z,ax3,'x');

    ax4 = nexttile; grid on; hold on;
    plot(time, rollFront, 'r-', time, rollRear, 'b-');
    ylabel('Roll [deg]'); ylim([-0.15 0.25]);
    legend("Front", "Rear")
    setAxesZoomConstraint(z,ax4,'x');

    linkaxes([ax1 ax2 ax3 ax4],'x');
    xlim([min(time) max(time)]);
end

function electronicsSkidpadPlot(data)
    %% Current and Voltage vs Time
    % tiled layout
    figure;
    tiledlayout("flow");
    sgtitle("Electronics");
    
    % total car current vs time
    nexttile;
    plot(data.Time, data.PMU_CURRENT)
    title("PMU Current vs Time")
    subtitle(sprintf("Average: %.5f [A]", mean(data.PMU_CURRENT)))
    ylabel("PMU Current [A]")
    xlabel("Time [s]")
    
    % battery current vs time
    nexttile;
    plot(data.Time, data.BatteryCurrent)
    title("Battery Current vs Time")
    subtitle(sprintf("Average: %.5f [A]", mean(data.BatteryCurrent)))
    ylabel("Battery Current [A]")
    xlabel("Time [s]")
    
    % alternator current vs time
    nexttile;
    plot(data.Time, data.AlternatorCurrent)
    hold on;
    title("Alternator Current vs Time")
    
    lsr = polyfit(data.Time, data.AlternatorCurrent, 1);
    plot(data.Time, polyval(lsr, data.Time))
    r_matrix = corrcoef(data.Time, data.AlternatorCurrent);
    
    subtitle(sprintf("Average: %.3f [A]\ny = %.2ex + %.1f, r = %.3f", mean(data.AlternatorCurrent), lsr(1), lsr(2), r_matrix(1,2)))
    ylabel("Alternator Current [A]")
    xlabel("Time [s]")
    
    % battery voltage vs time
    nexttile;
    plot(data.Time, data.BatteryVolts)
    title("Battery Voltage vs Time")
    subtitle(sprintf("Average: %.5f [V]", mean(data.BatteryVolts)))
    ylabel("Battery Voltage [V]")
    xlabel("Time [s]")
    
    %% alternator current vs EngineRPM scatter plot
    figure;
    scatter(data.EngineRPM, data.AlternatorCurrent, 10, "filled");
    alpha 0.35; hold on;
    
    title("Alternator Current vs EngineRPM")
    lsr = polyfit(data.EngineRPM, data.AlternatorCurrent, 1);
    plot(data.EngineRPM, polyval(lsr, data.EngineRPM))
    r_matrix = corrcoef(data.EngineRPM, data.AlternatorCurrent);
    
    subtitle(sprintf("y = %.2ex + %.1f, r = %.3f", lsr(1), lsr(2), r_matrix(1,2)))
    ylabel("Alternator Current [A]")
    xlabel("EngineRPM [RPM]")

    %% All currents toghether (not sure if this is helpful)
    figure;
    hold on;
    title("Currents vs Time")
    % alternator current vs time
    plot(data.Time, data.AlternatorCurrent)
    % PMU current vs time
    plot(data.Time, data.PMU_CURRENT)
    % battery current vs time
    plot(data.Time, data.BatteryCurrent)

    legend("Alternator", "PMU", "Battery", "Location", "east")
    xlabel("Time [s]")
    ylabel("Current [A]")
end
