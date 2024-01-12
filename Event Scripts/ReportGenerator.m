%% Report Generator
clear; clf;

%% Accel
publish("AccelSummary.m","format","pdf", showCode=false, outputDir=".\")
movefile("AccelSummary.pdf", outputFilename);
fprintf("\n==Done!=========\n")