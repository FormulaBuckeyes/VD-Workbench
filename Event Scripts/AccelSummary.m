%% Acceleration Report
clf; close all;
[filename, path] = uigetfile('*.csv', 'Select MoTeC Output File (.csv)');
data = motecImport(filename,pwd);
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
outputFilename = sprintf("Accel%s_%s.pdf", ...
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

function suspensionAccelPlot(data,smoothFactor,t)
    time = data.Time;
    SuspPosFL = data.SuspPosFL-data.SuspPosFL(1);
    SuspPosFR = data.SuspPosFR-data.SuspPosFR(1);
    SuspPosRL = data.SuspPosRL-data.SuspPosRL(1);
    SuspPosRR = data.SuspPosRR-data.SuspPosRR(1);
    SP_LF = smoothdata(SuspPosFL,'gaussian',smoothFactor);
    SP_RF = smoothdata(SuspPosFR,'gaussian',smoothFactor);
    SP_LR = smoothdata(SuspPosRL,'gaussian',smoothFactor);
    SP_RR = smoothdata(SuspPosRR,'gaussian',smoothFactor);
    
    figure;
    tiledlayout(2,2); sgtitle(sprintf('Damper Positions - Time: %.3f [s]', t));
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