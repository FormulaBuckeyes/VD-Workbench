% Electronics - Not finished

%% Current and Voltage vs Time
data = run

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

%% All Currents Plots
figure;
hold on;
title("Current vs Time")

% total car current vs time
plot(data.Time, data.PMU_CURRENT)

% alternator current vs time
plot(data.Time, data.AlternatorCurrent)

% battery current vs time
plot(data.Time, data.BatteryCurrent)

xlabel("Time [s]")
ylabel("Current [A]")
legend("PMU", "Alternator", "Battery", "Location", "east")







