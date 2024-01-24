%% Report Generator
clear; clf;

reportType = 'a';
% a - accel
% s - skidpad
% x - autoX / endurance (soon)
% c - coastdown (soon)

saveData = 'n';
% 'y' to save parsed individual runs as .mat files

switch lower(reportType)
    case 'a'
        %% Accel
        publish("AccelSummary.m","format","pdf", showCode=false,outputDir="./");
        movefile("AccelSummary.pdf", outputFilename);
        fprintf("File Created in path %s",outputFilename);
        fprintf("\n==Done!=========\n")
        web(outputFilename)

    case 's'
        %% Skidpad
        publish("SkidpadSummary.m","format","pdf", showCode=false,outputDir="./");
        movefile("SkidpadSummary.pdf", outputFilename);
        fprintf("File Created in path %s",outputFilename);
        fprintf("\n==Done!=========\n")
        web(outputFilename)

    otherwise
        fprintf("Nothing to generate - invalid report type\n")
end

% Saving trimmed run (Change at the top of the script)
if saveData == 'y'
    t = string(datetime('now', 'Format','MM_dd_yyyy_hh_mm',TimeZone='local'));
    for i = 1:length(fieldnames(lapData))
        RunName = strcat(t,'_',string(lapTimes(i)),'.mat');
        save(RunName,'lapData')
    end
end