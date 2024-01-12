%% EXPORT WITH MPH FOR SPEED!!!
clc; clear; close all;
data = motecImport('Accel2.csv',pwd);
SaveOutput = ''; %% Set SaveOutput = 'y' to save output files

[pk,lc] = findpeaks(data.GPSSpeed,'MinPeakHeight',60,'MinPeakDistance',1000);
data.Distance = cumtrapz(data.Time,data.GPSSpeed*0.447); %% mph to m/s
N = length(pk);
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
    % Outputting variables, trimming accel run
    var = strcat('r',num2str(k));
    Launch_time.(var) = time;
    launch.(var) = temp_dat(l1_buffer:l2,:);
    run = launch.(var);

    AccelDisp(run,time);
    % Saving trimmed run (Change at the top of the script)
    if SaveOutput == 'y'
        t = string(datetime('now', 'Format','MM_dd_yyyy_hh_mm',TimeZone='local'));
        LaunchName = strcat(t,'_',string(time),'.mat');
        save(LaunchName,'run')
    end
end


function [] = AccelDisp(data,t)
    figure;
    data.Distance = data.Distance-data.Distance(1);
    spacing = data.Time(2)-data.Time(1);
    n = int64(0.25/spacing); % 0.25 second window size 
    time = data.Time;
    gLongf = smoothdata(data.GForceLongC185,'gaussian',n);
    gLong = data.GForceLongC185;

    tiledlayout(4,1); sgtitle(sprintf('Accel Time: %.3f [s]', t));

    z = zoom;
    z.Motion = 'Horizontal';

    ax1 = nexttile;
    plot(time,data.GPSSpeed,'b-'); grid on; hold on;
    plot(time,data.DriveSpeed,'r-')
    setAxesZoomConstraint(z,ax1,'x');
    ylabel('Speed [mph]'); ylim([0 70]);
    legend('GPS Speed','Drive Speed','Location','southeast');

    ax2 = nexttile;
    slip = ((data.DriveSpeed)./data.GPSSpeed-1);
    plot(time,slip,'b-'); grid on;
    setAxesZoomConstraint(z,ax2,'x');
    ylabel('Slip'); ylim([0 max(slip)+5]);
    
    ax3 = nexttile;
    plot(time,data.EngineRPM,'b-'); grid on; hold on;
    plot(time,data.LaunchAimRPM,'r-');
    setAxesZoomConstraint(z,ax3,'x');
    ylabel('Engine Speed [RPM]'); ylim([4000 12500]);
    legend('RPM','Launch RPM Target','Location','southeast')

    ax4 = nexttile; hold on;
    plot(time,gLongf,'b-');
    plot(time,gLong,'r.','MarkerSize',1); 
    grid on;
    setAxesZoomConstraint(z,ax4,'x');
    ylabel('Long G'); ylim([-0.3 1.3]);
    legend('Filtered','Raw','Location','northeast');

    linkaxes([ax1 ax2 ax3 ax4],'x');
    xlim([min(time) max(time)]);
    % Suspension Plotting 1
    [heave,pitch] = SusCalc(data,n);
    figure;
    tiledlayout(3,1); sgtitle(sprintf('Sus Heave and Pitch - Time: %.3f [s]', t));
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

    linkaxes([ax1 ax2 ax3 ax4],'x');
    xlim([min(time) max(time)]);
    % Suspension Plotting 2
    SusDisp(data,n,t);
end

function [heave,pitch] = SusCalc(data,smoothFactor)
    SuspPosFL = data.SuspPosFL-data.SuspPosFL(1);
    SuspPosFR = data.SuspPosFR-data.SuspPosFR(1);
    SuspPosRL = data.SuspPosRL-data.SuspPosRL(1);
    SuspPosRR = data.SuspPosRR-data.SuspPosRR(1);
    SP_LF = smoothdata(SuspPosFL,'gaussian',smoothFactor);
    SP_RF = smoothdata(SuspPosFR,'gaussian',smoothFactor);
    SP_LR = smoothdata(SuspPosRL,'gaussian',smoothFactor);
    SP_RR = smoothdata(SuspPosRR,'gaussian',smoothFactor);
    MRF = 0.955; MRR = 0.99; L = 1616; % Motion Ratios [~] + Wheelbase [mm]
    heave = SP_LF+SP_RF+SP_LR+SP_RR;
    pitch = atand(((SP_LF+SP_RF)*MRF/2-(SP_LR-SP_RR)*MRR/2)/L);
end

function SusDisp(data,smoothFactor,t)
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