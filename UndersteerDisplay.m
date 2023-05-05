function UndersteerDisplay(plotTitle, time, WA, AA, UA)
subplot(2,1,1)
plot(time,WA,'r', time,AA,'b')
legend('Wheel Angle', 'Ackermann Angle')
title(plotTitle)

subplot(2,1,2)
plot(time,UA,'k')
line([min(time) max(time)], [0 0])
line([min(time) max(time)], [mean(UA) mean(UA)])
legend('Understeer Angle', '0', sprintf('Average: %f', mean(UA)))
end