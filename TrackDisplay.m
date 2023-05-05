function [] = TrackDisplay(long, lat, data)
%TrackDisplay Visualize the track shape, and overlay variables on track
%   Data is optional - if given it will apply a gradient to the track based
%   on the value at that point on track

arguments
    long (1,:)
    lat (1,:)
    data = zeros(size(lat))'
end

% Code adapted from 
% https://www.mathworks.com/matlabcentral/answers/5042-how-do-i-vary-color-along-a-2d-line
x = long;
y = lat;
z = data'; % invert with ' to make it one row instead of col
col = data';  % This is the color, vary with data in this case. inverted
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',1);
colorbar;
colormap(turbo);

% Unfortunately, there is no color gradient workaround for geoplots (that 
% I know of), but if you just want a to-scale track map use this command
% instead:
% geoplot(lat, long);

end