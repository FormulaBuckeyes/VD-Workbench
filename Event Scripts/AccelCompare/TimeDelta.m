function TimeDelta(datum, data,color_index)
    % Dependent on proper figure setup in AccelSetup & AccelSetupDist!!
    t = max(data.Time);
    colors = ['k','b','r','m','c','g','y'];
    c_line = strcat(colors(color_index),'-');
    i1 = find(datum.Time>=0,1,'first');
    datum = datum(i1:length(datum.Distance),:);
    i1 = find(data.Time>=0,1,'first');
    data = data(i1:length(data.Distance),:);
    distance_ref = 0.3:0.1:75.3;
    delta = zeros(1,length(distance_ref));
    for i = 1:length(distance_ref)
        datum_index = find(datum.Distance>=distance_ref(i),1,'first');
        data_index = find(data.Distance>=distance_ref(i),1,'first');
        delta(i) = datum.Time(datum_index)-data.Time(data_index);
    end
    spacing = data.Time(2)-data.Time(1);
    n = int64(0.25/spacing); % 0.25 second window size 
    delta = -smoothdata(delta,'gaussian',n);
    figure(4);
    nexttile(2); hold on;
    legendVal = strcat('DelTime',': ',string(t));
    plot(distance_ref,delta,c_line,'DisplayName',legendVal); 
end