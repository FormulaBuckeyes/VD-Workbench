function [] = AccelSetup(data)
    %% Variable Setup:
    data.Distance = data.Distance-data.Distance(1);
    spacing = data.Time(2)-data.Time(1);
    n = int64(0.25/spacing); % 0.25 second window size 
    time = data.Time;
    t = max(data.Time);
    gLongf = smoothdata(data.GForceLongC185,'gaussian',n);
    gLong = data.GForceLongC185;
    colors = ['k','b','r','m','c','g','y'];
    c_line = strcat(colors(1),'-');
    c_dotline = strcat(colors(1),'-.');
    c_dot = strcat(colors(1),'.');

    %% Main Page_Figure 1
    figure(1);
    f = tiledlayout(4,1); sgtitle('Accel Main Page');
    xlabel(f,'Time [s]');
    z = zoom;
    z.Motion = 'Horizontal';

    ax1 = nexttile(1); grid on; hold on;
    legendVal = strcat('GPS Speed',': ',string(t));
    plot(time,data.GPSSpeed,c_line,'DisplayName',legendVal); 
    legendVal = strcat('Drive Speed',': ',string(t));
    plot(time,data.DriveSpeed,c_dotline,'DisplayName',legendVal)
    setAxesZoomConstraint(z,ax1,'x');
    ylabel('Speed [mph]'); ylim([0 70]);
    legend('Location','Best');

    ax2 = nexttile(2);
    slip = ((data.DriveSpeed)./data.GPSSpeed-1);
    legendVal = strcat('Slip',': ',string(t));
    plot(time,slip,c_line,'DisplayName',legendVal); grid on;
    setAxesZoomConstraint(z,ax2,'x');
    ylabel('Slip'); ylim([0 max(slip)+5]); % Probably need to edit this tbh
    legend('Location','southeast');
    
    ax3 = nexttile(3);
    legendVal = strcat('RPM',': ',string(t));
    plot(time,data.EngineRPM,c_line,'DisplayName',legendVal); grid on; hold on;
    legendVal = strcat('RPM Limit',': ',string(t));
    plot(time,data.LaunchAimRPM,c_dotline,'DisplayName',legendVal);
    setAxesZoomConstraint(z,ax3,'x');
    ylabel('Engine Speed [RPM]'); ylim([4000 12500]);
    legend('Location','southeast');

    ax4 = nexttile(4); hold on;
    legendVal = strcat('Filtered GLong',': ',string(t));
    plot(time,gLongf,c_line,'DisplayName',legendVal);
    legendVal = strcat('Raw GLong',': ',string(t));
    plot(time,gLong,c_dot,'MarkerSize',1,'DisplayName',legendVal); 
    grid on;
    setAxesZoomConstraint(z,ax4,'x');
    ylabel('Long G'); ylim([-0.3 1.3]);
    legend('Location','northeast');

    linkaxes([ax1 ax2 ax3 ax4],'x');
    xlim([min(time) max(time)]);

    %% Suspension Figure 1
    SuspPosFL = data.SuspPosFL-data.SuspPosFL(1);
    SuspPosFR = data.SuspPosFR-data.SuspPosFR(1);
    SuspPosRL = data.SuspPosRL-data.SuspPosRL(1);
    SuspPosRR = data.SuspPosRR-data.SuspPosRR(1);
    SP_LF = smoothdata(SuspPosFL,'gaussian',n);
    SP_RF = smoothdata(SuspPosFR,'gaussian',n);
    SP_LR = smoothdata(SuspPosRL,'gaussian',n);
    SP_RR = smoothdata(SuspPosRR,'gaussian',n);

    % NEED TO UPDATE BELOW TO WORK WITH CAR OBJECT:
    MRF = 0.955; MRR = 0.99; L = 1616; % Motion Ratios [~] + Wheelbase [mm]

    heave = SP_LF+SP_RF+SP_LR+SP_RR;
    pitch = atand(((SP_LF+SP_RF)*MRF/2-(SP_LR-SP_RR)*MRR/2)/L);

    figure(2);
    f = tiledlayout(3,1); sgtitle('Suspension Heave and Pitch');
    z = zoom;
    z.Motion = 'Horizontal';
    xlabel(f,'Time [s]');

    ax1 = nexttile(1); grid on; hold on;
    legendVal = strcat('GPS Speed',': ',string(t));
    plot(time,data.GPSSpeed,c_line,'DisplayName',legendVal); 
    legendVal = strcat('Drive Speed',': ',string(t));
    plot(time,data.DriveSpeed,c_dotline,'DisplayName',legendVal)
    setAxesZoomConstraint(z,ax1,'x');
    ylabel('Speed [mph]'); ylim([0 70]);
    legend('Location','Best');

    ax2 = nexttile(2); grid on; hold on;
    legendVal = strcat('Heave',': ',string(t));
    plot(time,heave,c_line,'DisplayName',legendVal); 
    ylabel('Heave [mm]'); ylim([-25 1])
    setAxesZoomConstraint(z,ax2,'x');
    legend('Location','Best');

    ax3 = nexttile(3); grid on; hold on;
    legendVal = strcat('Pitch',': ',string(t));
    plot(time,pitch,c_line,'DisplayName',legendVal);
    ylabel('Pitch [deg]'); ylim([-0.15 0.25]);
    setAxesZoomConstraint(z,ax3,'x');
    legend('Location','Best');

    linkaxes([ax1 ax2 ax3 ax4],'x');
    xlim([min(time) max(time)]);
    
    %% Damper Positions Figure
    figure(3);
    f = tiledlayout(2,2); sgtitle('Damper Positions');
    z = zoom;
    z.Motion = 'Horizontal';
    xlabel(f,'Time [s]');

    ax1 = nexttile(1); grid on; hold on;
    legendVal = strcat('Raw',': ',string(t));
    plot(time,SuspPosFL,c_line,'MarkerSize',3,'DisplayName',legendVal); 
    legendVal = strcat('Filtered',': ',string(t));
    plot(time,SP_LF,c_line,'DisplayName',legendVal);
    setAxesZoomConstraint(z,ax1,'x'); 
    ylabel('Damper Position [mm]'); ylim([-3 8]);
    legend('Location','Best'); title('Front Left');

    ax2 = nexttile(2); grid on; hold on;
    legendVal = strcat('Raw',': ',string(t));
    plot(time,SuspPosFR,c_dot,'MarkerSize',3,'DisplayName',legendVal);
    legendVal = strcat('Filtered',': ',string(t));
    plot(time,SP_RF,c_line,'DisplayName',legendVal);
    setAxesZoomConstraint(z,ax2,'x');
    ylabel('Damper Position [mm]'); ylim([-3 8]);
    legend('Location','Best'); title('Front Right');

    ax3 = nexttile(3); grid on; hold on;
    legendVal = strcat('Raw',': ',string(t));
    plot(time,SuspPosRL,c_dot,'MarkerSize',3,'DisplayName',legendVal); 
    legendVal = strcat('Filtered',': ',string(t));
    plot(time,SP_LR,c_line,'DisplayName',legendVal);
    setAxesZoomConstraint(z,ax3,'x');
    ylabel('Damper Position [mm]');  ylim([-7 1]);
    legend('Location','Best'); title('Rear Left');

    ax4 = nexttile(4); grid on; hold on;
    legendVal = strcat('Raw',': ',string(t));
    plot(time,SuspPosRR,c_dot,'MarkerSize',3,'DisplayName',legendVal); 
    legendVal = strcat('Filtered',': ',string(t));
    plot(time,SP_RR,c_line,'DisplayName',legendVal);
    setAxesZoomConstraint(z,ax4,'x');
    ylabel('Damper Position [mm]'); ylim([-7 1]);
    legend('Location','Best'); title('Rear Right');

    linkaxes([ax1 ax2 ax3 ax4],'x');
    xlim([min(time) max(time)]);

    %% Delta Time Setup
    figure(4);
    f = tiledlayout(2,1); sgtitle('Delta Time Comparison');
    z = zoom;
    z.Motion = 'Horizontal';
    xlabel(f,'Distance [m]'); 

    ax1 = nexttile(1); grid on; hold on;
    legendVal = strcat('GPS Speed',': ',string(t));
    plot(data.Distance,data.GPSSpeed,c_line,'DisplayName',legendVal); 
    legendVal = strcat('Drive Speed',': ',string(t));
    plot(data.Distance,data.DriveSpeed,c_dotline,'DisplayName',legendVal)
    setAxesZoomConstraint(z,ax1,'x');
    ylabel('Speed [mph]'); ylim([0 70]);
    xlim([0 75.3]);
    legend('Location','Best');

    ax2 = nexttile(2);
    legendVal = strcat('Datum',': ',string(t));
    zero_line = zeros(1,length(data.Distance));
    plot(data.Distance,zero_line,c_line,'DisplayName',legendVal); grid on;
    setAxesZoomConstraint(z,ax2,'x');
    xlim([0 75.3]);
    ylabel('Time Delta [s]');
    legend('Location','Best');
    linkaxes([ax1 ax2],'x');

end