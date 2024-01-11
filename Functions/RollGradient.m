function [RG_F,RG_R,RG] = RollGradient(motec,x)
%% Enter x = 0 for no plots, x = 1 for plots
GLAT = smoothdata(motec.GForceLatC185,'gaussian',100);

SuspPosFL = motec.SuspPosFL-motec.SuspPosFL(1);
SuspPosFR = motec.SuspPosFR-motec.SuspPosFR(1);
SuspPosRL = motec.SuspPosRL-motec.SuspPosRL(1);
SuspPosRR = motec.SuspPosRR-motec.SuspPosRR(1);
SuspPosFL_F = smoothdata(SuspPosFL,'gaussian',100);
SuspPosFR_F = smoothdata(SuspPosFR,'gaussian',100);
SuspPosRL_F = smoothdata(SuspPosRL,'gaussian',100);
SuspPosRR_F = smoothdata(SuspPosRR,'gaussian',100);

% Roll
MRF = 0.955; MRR = 0.99;
TF = 1200; TR = 1175;

roll = -atand(((SuspPosFL_F-SuspPosFR_F)*MRF+(SuspPosRL_F-SuspPosRR_F)*MRR)/(TF+TR));
roll_F = -atand((SuspPosFL_F-SuspPosFR_F)*MRF/TF);
roll_R = -atand((SuspPosRL_F-SuspPosRR_F)*MRR/TR);

fit_F = polyfit(GLAT,roll_F,1);
fit_R = polyfit(GLAT,roll_R,1);
fit = polyfit(GLAT,roll,1);

RG_F = fit_F(1);
RG_R = fit_R(1);
RG = fit(1);

if x == 1
figure; hold on; grid on;
title('Front Roll Gradient');
plot(GLAT,roll_F,'b.','MarkerSize',1);
plot(GLAT,GLAT*fit_F(1)+fit_F(2),'r-','LineWidth',5);
xlim([-2.5 2.5]); ylim([-1.5 1.5]);
text(1, 1, sprintf('y = %.3f*x + %.3f\n',fit_F));
xlabel('Lateral Accel [G]'); ylabel('Roll [deg]');

figure; hold on; grid on;
title('Rear Roll Gradient');
plot(GLAT,roll_F,'b.','MarkerSize',1);
plot(GLAT,GLAT*fit_R(1)+fit_R(2),'r-','LineWidth',5);
xlim([-2.5 2.5]); ylim([-1.5 1.5]);
text(1, 1, sprintf('y = %.3f*x + %.3f\n',fit_R));
xlabel('Lateral Accel [G]'); ylabel('Roll [deg]');

figure; hold on; grid on;
title('Combined Roll Gradient');
plot(GLAT,roll_F,'b.','MarkerSize',1);
plot(GLAT,GLAT*fit(1)+fit(2),'r-','LineWidth',5);
xlim([-2.5 2.5]); ylim([-1.5 1.5]);
text(1, 1, sprintf('y = %.3f*x + %.3f\n',fit));
xlabel('Lateral Accel [G]'); ylabel('Roll [deg]');

end

end