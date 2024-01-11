clc; clear; close all;

[filename, path] = uigetfile('*.mat', 'Select First Parsed Launch File');
ff = fullfile(path,filename); load(ff);
data = run;
[filename, path] = uigetfile('*.mat', 'Select Second Parsed Launch File');
ff = fullfile(path,filename); load(ff);
data2 = run;

AccelDispC_Time(data,data2)
AccelDispC_Dist(data,data2)

function [] = AccelDispC_Time(data,data2)
    figure;
    data.Distance = data.Distance-data.Distance(1);
    spacing = data.Time(2)-data.Time(1);
    n = int64(0.25/spacing);
    time = data.Time;
    gLongf = smoothdata(data.GForceLongC185,'gaussian',n);
    gLong = data.GForceLongC185;

    data2.Distance = data2.Distance-data2.Distance(1);
    spacing = data2.Time(2)-data2.Time(1);
    n = int64(0.25/spacing);
    time2 = data2.Time;
    gLongf2 = smoothdata(data2.GForceLongC185,'gaussian',n);
    gLong2 = data2.GForceLongC185;

    tiledlayout(4,1); sgtitle('Accel Comparison');

    z = zoom;
    z.Motion = 'Horizontal';

    ax1 = nexttile;
    plot(time,data.GPSSpeed,'b-'); grid on; hold on;
    plot(time,data.DriveSpeed,'b-.')
    plot(time2,data2.GPSSpeed,'r-'); 
    plot(time2,data2.DriveSpeed,'r-.')
    setAxesZoomConstraint(z,ax1,'x');
    ylabel('Speed [mph]'); ylim([0 70]);
    legend('GPS Speed 1','Drive Speed 1','GPS Speed 2','Drive Speed 2','Location','southeast');

    ax2 = nexttile;
    slip = ((data.DriveSpeed)./data.GPSSpeed-1);
    plot(time,slip,'b-'); grid on; hold on;
    slip2 = ((data2.DriveSpeed)./data2.GPSSpeed-1);
    plot(time2,slip2,'r-');
    setAxesZoomConstraint(z,ax2,'x');
    ylabel('Slip'); ylim([0 max(slip)+5]);
    legend('Slip 1','Slip 2');
    
    ax3 = nexttile;
    plot(time,data.EngineRPM,'b-'); grid on; hold on;
    plot(time,data.LaunchAimRPM,'b-.');
    plot(time2,data2.EngineRPM,'r-');
    plot(time2,data2.LaunchAimRPM,'r-.');    
    setAxesZoomConstraint(z,ax3,'x');
    ylabel('Engine Speed [RPM]'); ylim([4000 12500]);
    legend('RPM 1','Launch RPM Target 1','RPM 2','Launch RPM Target 2','Location','southeast')

    ax4 = nexttile; hold on;
    plot(time,gLongf,'b-');
    plot(time,gLong,'b.','MarkerSize',1); 
    plot(time2,gLongf2,'r-');
    plot(time2,gLong2,'r.','MarkerSize',1); 
    grid on;
    setAxesZoomConstraint(z,ax4,'x');
    ylabel('Long G'); ylim([-0.3 1.3]);
    legend('Filtered','Raw','Location','northeast');

    linkaxes([ax1 ax2 ax3 ax4],'x');
    xlim([min(time) max(time)]);
end

function [] = AccelDispC_Dist(data,data2)
    figure;
    % Correct Distance for 1st dataset
    l1 = find(data.Distance >= 0.3,1,'first');
    l2 = find(data.Distance >= 75.3,1,'first');
    data = data(l1:l2,:);
    data.Distance = data.Distance-data.Distance(1);
    spacing = data.Time(2)-data.Time(1);
    n = int64(0.25/spacing);
    time = data.Time;
    dist = data.Distance;
    gLongf = smoothdata(data.GForceLongC185,'gaussian',n);
    gLong = data.GForceLongC185;
    % Correct Distance for 2nd dataset
    l1 = find(data2.Distance >= 0.3,1,'first');
    l2 = find(data2.Distance >= 75.3,1,'first');
    data2 = data2(l1:l2,:);
    data2.Distance = data2.Distance-data2.Distance(1);
    spacing = data2.Time(2)-data2.Time(1);
    n = int64(0.25/spacing);
    time2 = data2.Time;
    dist2 = data2.Distance;
    gLongf2 = smoothdata(data2.GForceLongC185,'gaussian',n);
    gLong2 = data2.GForceLongC185;

    tiledlayout(5,1); sgtitle('Accel Comparison');

    z = zoom;
    z.Motion = 'Horizontal';

    ax1 = nexttile;
    plot(dist,data.GPSSpeed,'b-'); grid on; hold on;
    plot(dist,data.DriveSpeed,'b-.')
    plot(dist2,data2.GPSSpeed,'r-'); 
    plot(dist2,data2.DriveSpeed,'r-.')
    setAxesZoomConstraint(z,ax1,'x');
    ylabel('Speed [mph]'); ylim([0 70]);
    legend('GPS Speed 1','Drive Speed 1','GPS Speed 2','Drive Speed 2','Location','southeast');

    ax2 = nexttile;
    slip = ((data.DriveSpeed)./data.GPSSpeed-1);
    plot(dist,slip,'b-'); grid on; hold on;
    slip2 = ((data2.DriveSpeed)./data2.GPSSpeed-1);
    plot(dist2,slip2,'r-');
    setAxesZoomConstraint(z,ax2,'x');
    ylabel('Slip'); ylim([0 max(slip)+5]);
    legend('Slip 1','Slip 2');
    
    ax3 = nexttile;
    plot(dist,data.EngineRPM,'b-'); grid on; hold on;
    plot(dist,data.LaunchAimRPM,'b-.');
    plot(dist2,data2.EngineRPM,'r-');
    plot(dist2,data2.LaunchAimRPM,'r-.');    
    setAxesZoomConstraint(z,ax3,'x');
    ylabel('Engine Speed [RPM]'); ylim([4000 12500]);
    legend('RPM 1','Launch RPM Target 1','RPM 2','Launch RPM Target 2','Location','southeast')

    ax4 = nexttile; hold on;
    plot(dist,gLongf,'b-');
    plot(dist,gLong,'b.','MarkerSize',1); 
    plot(dist2,gLongf2,'r-');
    plot(dist2,gLong2,'r.','MarkerSize',1); 
    grid on;
    setAxesZoomConstraint(z,ax4,'x');
    ylabel('Long G'); ylim([-0.3 1.3]);
    legend('Filtered','Raw','Location','northeast');

    ax5 = nexttile; hold on; grid on;
    setAxesZoomConstraint(z,ax5,'x');
    plot(dist,time); plot(dist2,time2);
    ylabel('Time [s]');


    linkaxes([ax1 ax2 ax3 ax4 ax5],'x');
    xlim([min(dist) max(dist)]);
end