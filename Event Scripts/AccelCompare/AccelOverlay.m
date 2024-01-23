function [] = AccelOverlay(data,i)
    %% Variable Setup:
    data.Distance = data.Distance-data.Distance(1);
    spacing = data.Time(2)-data.Time(1);
    n = int64(0.25/spacing); % 0.25 second window size 
    time = data.Time;
    t = max(data.Time);
    gLongf = smoothdata(data.GForceLongC185,'gaussian',n);
    gLong = data.GForceLongC185;
    colors = ['k','b','r','m','c','g','y'];
    c_line = strcat(colors(i),'-');
    c_dotline = strcat(colors(i),'-.');
    c_dot = strcat(colors(i),'.');
    %% Main Page_Figure 1
    figure(1);

    nexttile(1); hold on;
    legendVal = strcat('GPS Speed',': ',string(t));
    plot(time,data.GPSSpeed,c_line,'DisplayName',legendVal); 
    legendVal = strcat('Drive Speed',': ',string(t));
    plot(time,data.DriveSpeed,c_dotline,'DisplayName',legendVal)

    nexttile(2); hold on;
    slip = ((data.DriveSpeed)./data.GPSSpeed-1);
    legendVal = strcat('Slip',': ',string(t));
    plot(time,slip,c_line,'DisplayName',legendVal);
    
    nexttile(3); hold on;
    legendVal = strcat('RPM',': ',string(t));
    plot(time,data.EngineRPM,c_line,'DisplayName',legendVal); grid on; hold on;
    legendVal = strcat('RPM Limit',': ',string(t));
    plot(time,data.LaunchAimRPM,c_dotline,'DisplayName',legendVal);

    nexttile(4); hold on;
    legendVal = strcat('Filtered GLong',': ',string(t));
    plot(time,gLongf,c_line,'DisplayName',legendVal);
    legendVal = strcat('Raw GLong',': ',string(t));
    plot(time,gLong,c_dot,'MarkerSize',1,'DisplayName',legendVal); 

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
    nexttile(1); hold on;
    legendVal = strcat('GPS Speed',': ',string(t));
    plot(time,data.GPSSpeed,c_line,'DisplayName',legendVal); 
    legendVal = strcat('Drive Speed',': ',string(t));
    plot(time,data.DriveSpeed,c_dotline,'DisplayName',legendVal)

    nexttile(2); hold on;
    legendVal = strcat('Heave',': ',string(t));
    plot(time,heave,c_line,'DisplayName',legendVal); 

    nexttile(3); grid on; hold on;
    legendVal = strcat('Pitch',': ',string(t));
    plot(time,pitch,c_line,'DisplayName',legendVal);


    %% Damper Positions Figure
    figure(3);

    nexttile(1);  hold on;
    legendVal = strcat('Raw',': ',string(t));
    plot(time,SuspPosFL,c_line,'MarkerSize',3,'DisplayName',legendVal); 
    legendVal = strcat('Filtered',': ',string(t));
    plot(time,SP_LF,c_line,'DisplayName',legendVal);

    nexttile(2); hold on;
    legendVal = strcat('Raw',': ',string(t));
    plot(time,SuspPosFR,c_dot,'MarkerSize',3,'DisplayName',legendVal);
    legendVal = strcat('Filtered',': ',string(t));
    plot(time,SP_RF,c_line,'DisplayName',legendVal);

    nexttile(3); grid on; hold on;
    legendVal = strcat('Raw',': ',string(t));
    plot(time,SuspPosRL,c_dot,'MarkerSize',3,'DisplayName',legendVal); 
    legendVal = strcat('Filtered',': ',string(t));
    plot(time,SP_LR,c_line,'DisplayName',legendVal);

    nexttile(4); grid on; hold on;
    legendVal = strcat('Raw',': ',string(t));
    plot(time,SuspPosRR,c_dot,'MarkerSize',3,'DisplayName',legendVal); 
    legendVal = strcat('Filtered',': ',string(t));
    plot(time,SP_RR,c_line,'DisplayName',legendVal);

    %% Delta Time Figure (ALWAYS PLOTS WITH RESPECT TO DISTANCE)
    figure(4)
    nexttile(1); hold on;
    legendVal = strcat('GPS Speed',': ',string(t));
    plot(data.Distance,data.GPSSpeed,c_line,'DisplayName',legendVal); 
    legendVal = strcat('Drive Speed',': ',string(t));
    plot(data.Distance,data.DriveSpeed,c_dotline,'DisplayName',legendVal)

end