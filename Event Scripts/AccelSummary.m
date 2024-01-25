%% Acceleration Report
clf; close all;
addpath("../Functions/");
[filename, path] = uigetfile('*.csv', 'Select MoTeC Output File (.csv)');
data = motecImport(filename,path);
metadata = motecMetadata(filename);
totalDistance = max(data.Distance);
totalTime = max(data.Time);

[lapData, lapTimes] = parseAccelRuns(data);

%% Summary

fprintf("Track: %s\n", metadata.track)
fprintf("Driver: %s\n", metadata.driver)
fprintf("Run Date: %s\n", metadata.logDate)
fprintf("Run Time: %s\n", metadata.logTime)
fprintf("Session Distance: %d m\n", totalDistance)
fprintf("Session Length: %d s\n", totalTime)
fprintf("Comments: %s\n", metadata.comment)
fprintf("Report Generated: %s\n", datetime("now"))

summaryTable = table((1:length(size(lapData)))',lapTimes', ...
    'VariableNames',["Lap #" "Lap Time"]);
disp(summaryTable)

fprintf("Average gLat: %f\n", mean(data.GForceLatC185(1:end-1)))

%%
for k=1:length(lapTimes)
    runID = strcat('r',num2str(k));
    n = int64(0.25/(data.Time(2)-data.Time(1))); % 0.25 second window size 
%% Suspension
suspensionAccelPlot(lapData.(runID),n,lapTimes(k))

end

%%
outputFilename = sprintf("%sAccel%s_%s.pdf", ...
    "../Logs/", ...
    strrep(metadata.logDate,"/","-"), ...
    strrep(sprintf("%.2f",min(lapTimes)),".","-"));

%%

function [runs, times] = parseAccelRuns(data)
    [pk,lc] = findpeaks(data.GPSSpeed,'MinPeakHeight',60,'MinPeakDistance',1000);
    data.Distance = cumtrapz(data.Time,data.GPSSpeed*0.447); %% mph to m/s
    N = length(pk);
    times = zeros(1,N);
    % Initial Parsing // Finding and splitting launches
    for k=1:N
        if k == 1
            i1 = 1;
            i2 = lc(k);
        else
            i1 = lc(k-1);
            i2 = lc(k);
        end
        n1 = find(data.ThrottlePos(i1:i2)>99 & data.GPSSpeed(i1:i2) < 0.21,1,'first')+i1;
        temp_dat = data(n1:i2,:);
    % Secondary Parsing // Calculating Accel Time
        % Finding where to start and stop timing
        temp_dat.Distance = temp_dat.Distance - temp_dat.Distance(1);
        l1 = find(temp_dat.Distance >= 0.3,1,'first');
        l2 = find(temp_dat.Distance >= 75.3,1,'first');
        temp_dat.Time = temp_dat.Time - temp_dat.Time(l1);    
        time = temp_dat.Time(l2)-temp_dat.Time(l1);
        % Adding 1 second buffer to get launch in its entirety
        l1_buffer = int64(l1-1/(temp_dat.Time(2)-temp_dat.Time(1)));
            if l1_buffer == 0
                l1_buffer = 1;
            end
        % Outputting variables
        var = strcat('r',num2str(k));
        runs.(var) = temp_dat(l1_buffer:l2,:);
        times(k) = time;
    end
end

function suspensionAccelPlot(data,smoothFactor,lapTime)
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
    MRF = 0.955; MRR = 0.99; L = 1616; % Motion Ratios [~] + Wheelbase [mm]
    
    % Heave & Pitch
    heave = SP_LF+SP_RF+SP_LR+SP_RR;
    pitch = atand(((SP_LF+SP_RF)*MRF/2-(SP_LR-SP_RR)*MRR/2)/L);
    
    figure;
    tiledlayout(3,1); sgtitle(sprintf('Sus Heave and Pitch - Time: %.3f [s]', lapTime));
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

    linkaxes([ax1 ax2 ax3],'x');
    xlim([min(time) max(time)]);

    % Damper Positions
    figure;
    tiledlayout(2,2); sgtitle(sprintf('Damper Positions - Time: %.3f [s]', lapTime));
    z = zoom;
    z.Motion = 'Horizontal';

    ax1 = nexttile; 
    plot(time,SuspPosFL,'r.','MarkerSize',3); grid on; hold on;
    plot(time,SP_LF,'b-');
    setAxesZoomConstraint(z,ax1,'x'); 
    ylabel('Damper Position [mm]'); xlabel('Time [s]'); ylim([-3 8]);
    legend('Raw','Filtered','Location','Best'); title('Front Left');

    ax2 = nexttile; 
    plot(time,SuspPosFR,'r.','MarkerSize',3); grid on; hold on;
    plot(time,SP_RF,'b-');
    setAxesZoomConstraint(z,ax2,'x');
    ylabel('Damper Position [mm]'); xlabel('Time [s]'); ylim([-3 8]);
    legend('Raw','Filtered','Location','Best'); title('Front Right');

    ax3 = nexttile; 
    plot(time,SuspPosRL,'r.','MarkerSize',3); grid on; hold on;
    plot(time,SP_LR,'b-');
    setAxesZoomConstraint(z,ax3,'x');
    ylabel('Damper Position [mm]'); xlabel('Time [s]'); ylim([-7 1]);
    legend('Raw','Filtered','Location','Best'); title('Rear Left');

    ax4 = nexttile; 
    plot(time,SuspPosRR,'r.','MarkerSize',3); grid on; hold on;
    plot(time,SP_RR,'b-');
    setAxesZoomConstraint(z,ax4,'x');
    ylabel('Damper Position [mm]'); xlabel('Time [s]'); ylim([-7 1]);
    legend('Raw','Filtered','Location','Best'); title('Rear Right');

    linkaxes([ax1 ax2 ax3 ax4],'x');
    xlim([min(time) max(time)]);
end

function electronicsAccelPlot(data)
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
    
    lsr = polyfit(data.Time, data.AlternatorCurrent, 1)
    plot(data.Time, polyval(lsr, data.Time))
    r_matrix = corrcoef(data.Time, data.AlternatorCurrent)
    
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
    alpha 0.01; hold on;
    
    title("Alternator Current vs EngineRPM")
    lsr = polyfit(data.EngineRPM, data.AlternatorCurrent, 1)
    plot(data.EngineRPM, polyval(lsr, data.EngineRPM))
    r_matrix = corrcoef(data.EngineRPM, data.AlternatorCurrent)
    
    subtitle(sprintf("y = %.2ex + %.1f, r = %.3f", lsr(1), lsr(2), r_matrix(1,2)))
    ylabel("Alternator Current [A]")
    xlabel("EngineRPM [RPM]")
end