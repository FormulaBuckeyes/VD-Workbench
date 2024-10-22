function [Outputs] = RollStiffness(motec,car)
[RG_F,RG_R,RG] = RollGradient(motec,0);
RG_F = abs(RG_F); RG_R = abs(RG_R); RG = abs(RG);
% Sprung Weights
W_SF = 123.69; % [kg]
W_SR = 136.72; % [kg]

% Track Width [mm]
% TF = 1200; TR = 1175;
TF = car.trackwidthFront*1e3; TR = car.trackwidthRear*1e3;

% CoG Height, Roll Center Front + Rear Heights [mm]
h_cog = 298.196;
h_RCf = 6.5;
h_RCr = 33.6;
h_roll = h_cog - (h_RCf + (h_RCr-h_RCf*W_SR)/(W_SF+W_SR));

M_Roll = h_roll*(W_SF+W_SR); % [kg mm]

% Roll Stiffness of Front + Rear Axels, K = [kg mm/deg]
K_Roll_Total = M_Roll/RG;
K_Roll_Front = K_Roll_Total*(RG_R/(RG_R+RG_F));
K_Roll_Rear = K_Roll_Total-K_Roll_Front;

% Wheel Rates [kg/mm]
WRf = 36.09549987/9.81;
WRr = 40.82810716/9.81;

% Roll Stiffness (By Wheel Rates) [kg mm/deg]
K_Roll_Front_Spring = TF^2*WRf/2*pi/180;
K_Roll_Rear_Spring = TR^2*WRr/2*pi/180;

% Roll Stiffness (By ARBs) [kg mm/deg]
K_Roll_Front_ARB = K_Roll_Front-K_Roll_Front_Spring;
K_Roll_Rear_ARB = K_Roll_Rear-K_Roll_Rear_Spring;

% "Actual ARB Rates" [kg mm/deg]
MR_Rollf = car.FrontARBMotionRatio;
MR_Rollr = car.RearARBMotionRatio;
SR_Roll_F = K_Roll_Front_ARB*MR_Rollf^2;
SR_Roll_R = K_Roll_Rear_ARB*MR_Rollr^2;

RollStiffnessComponents = ["Total Roll Stiffness";"Front Roll Stiffness";"Rear Roll Stiffness";
    "Front Roll Stiffness - Spring"; "Rear Roll Stiffness - Spring";"Front Roll Stiffness - ARB";
    "Rear Roll Stiffness - ARB"];
Vals = [K_Roll_Total;K_Roll_Front;K_Roll_Rear;K_Roll_Front_Spring;K_Roll_Rear_Spring;
    K_Roll_Front_ARB;K_Roll_Rear_ARB];

Outputs = table(RollStiffnessComponents,Vals);

end