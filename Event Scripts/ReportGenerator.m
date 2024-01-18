%% Report Generator
clear; clf;

%% Accel
publish("AccelSummary.m","format","pdf", showCode=false,outputDir="./");
movefile("AccelSummary.pdf", outputFilename);
fprintf("File Created in path %s",outputFilename);
fprintf("\n==Done!=========\n")