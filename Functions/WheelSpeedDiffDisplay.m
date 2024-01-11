function [] = WheelSpeedDiffDisplay(WSF, WSR, WSO, run, time)
%WheelSpeedDiffDisplay Displays the Front, Rear, Optimal Wheel Speed
%Differences
%   Outputs a 3r x 1c subplot graph 

tiledlayout(3,1);
ax1 = nexttile();
plot(time,WSR,'k-'); hold on; grid on;
plot(time,WSF,'r-');
plot(time,WSO,'b--');
legend("Rear", "Front", "Optimal")
ylabel("Wheel Speed Diffs")
ax2 = nexttile();
plot(time,run.ThrottlePos); grid on;
ylabel("Throttle Pos")
ax3 = nexttile();
plot(time,run.BrakePressureFront); grid on;
ylabel("Brake Pressure")

linkaxes([ax1, ax2, ax3],'x')

end