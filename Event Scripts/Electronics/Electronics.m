% Electronics - Not finished

%% Current and Voltage vs Time
% tiled layout
figure;
tiledlayout("flow");
sgtitle("Electronics");

% total car current vs time
nexttile;
plot(run.Time, run.PMU_CURRENT)
title("PMU Current vs Time")
subtitle(sprintf("Average: %.5f [A]", mean(run.PMU_CURRENT)))
ylabel("PMU Current [A]")
xlabel("Time [s]")

% battery current vs time
nexttile;
plot(run.Time, run.BatteryCurrent)
title("Battery Current vs Time")
subtitle(sprintf("Average: %.5f [A]", mean(run.BatteryCurrent)))
ylabel("Battery Current [A]")
xlabel("Time [s]")

% battery voltage vs time
nexttile;
plot(run.Time, run.BatteryVolts)
title("Battery Voltage vs Time")
subtitle(sprintf("Average: %.5f [V]", mean(run.BatteryVolts)))
ylabel("Battery Voltage [V]")
xlabel("Time [s]")

% battery voltage derivative vs time
nexttile;
plot(run.Time, gradient(smoothdata(run.BatteryVolts)))
title("Batt Volt Derivative vs Time")
subtitle(sprintf("Average: %.5e [V/s]", mean(gradient(smoothdata(run.BatteryVolts)))))
ylabel("Batt Volt Derivative [V/s]")
xlabel("Time [s]")



%% Voltage Derivative Scatter Plots
% tiled layout
figure;
tiledlayout("vertical");
sgtitle("Electronics");

% battery voltage derivative vs throttle
nexttile;
scatter(run.ThrottlePos, gradient(smoothdata(run.BatteryVolts)), 10, "filled");
h = lsline; h.Color = 'b';
alpha 0.01
title("Batt Volt Deriv vs Throttle")
ylabel("Batt Volt Deriv [V/s]")
xlabel("Throttle [%]")

% battery voltage derivative vs EngineRPM
nexttile;
scatter(run.EngineRPM, gradient(smoothdata(run.BatteryVolts)), 10, "filled");
h = lsline; h.Color = 'b';
alpha 0.01
title("Batt Volt Deriv vs EngineRPM")
ylabel("Batt Volt Deriv [V/s]")
xlabel("EngineRPM [RPM]")

% battery voltage derivative vs DriveSpeed
nexttile;
scatter(run.DriveSpeed, gradient(smoothdata(run.BatteryVolts)), 10, "filled");
h = lsline; h.Color = 'b';
alpha 0.01
title("Batt Volt Deriv vs DriveSpeed")
ylabel("Batt Volt Deriv [V/s]")
xlabel("DriveSpeed [mph]")


% %% Battery Current Scatter Plots
% % tiled layout
% figure;
% tiledlayout("vertical");
% sgtitle("Electronics");
% 
% % battery current vs throttle
% nexttile;
% scatter(run.ThrottlePos, run.BatteryCurrent, 10, "filled");
% h = lsline; h.Color = 'b';
% alpha 0.01
% title("BatteryCurrent vs Throttle")
% ylabel("BatteryCurrent")
% xlabel("Throttle")
% 
% % battery current vs EngineRPM
% nexttile;
% scatter(run.EngineRPM, run.BatteryCurrent, 10, "filled");
% h = lsline; h.Color = 'b';
% alpha 0.01
% title("BatteryCurrent vs EngineRPM")
% ylabel("BatteryCurrent")
% xlabel("EngineRPM")
% 
% % battery current vs DriveSpeed
% nexttile;
% scatter(run.DriveSpeed, run.BatteryCurrent, 10, "filled");
% h = lsline; h.Color = 'b';
% alpha 0.01
% title("BatteryCurrent vs DriveSpeed")
% ylabel("BatteryCurrent")
% xlabel("DriveSpeed")



% %% Voltage Derivative vs Battery Current
% % tiled layout
% figure;
% tiledlayout("vertical");
% sgtitle("Electronics");
% 
% % battery voltage derivative vs battery current
% nexttile;
% scatter(run.BatteryCurrent, gradient(smoothdata(run.BatteryVolts)), 10, "filled");
% h = lsline; h.Color = 'b';
% alpha 0.01
% title("Batt Volt Derivative vs BatteryCurrent")
% ylabel("Batt Volt Derivative")
% xlabel("BatteryCurrent")



% figure;
% % battery voltage derivative vs AccelLong
% nexttile;
% scatter(run.VehicleAccelLongIMU, gradient(smoothdata(run.BatteryVolts)), 10, "filled");
% h = lsline; h.Color = 'b';
% alpha 0.01
% title("Batt Volt Deriv vs AccelLong")
% ylabel("Batt Volt Deriv [V/s]")
% xlabel("AccelLong [G]")







