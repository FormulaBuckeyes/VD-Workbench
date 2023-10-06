function RollDistributionDisplay(time, distFront, distRear, accelLat)
%RollDistributionDisplay Plots time vs front, rear dists and accelLat
plot(time,distFront,'r', time,distRear,'b', time,accelLat,'g')
legend('Front Distribution', 'Rear Distribution', 'Lat Accel')
end