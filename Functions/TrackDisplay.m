function [] = TrackDisplay(long, lat, data, colorscheme, colorLimits)
%TrackDisplay Visualize the track shape, and overlay variables on track
%   long, lat - GPS Coordinates for the longitude and latitude of the car  
%   data - optional, if given it will apply a gradient to the track based
%   on the value of data at that point on track
%   colorscheme - optional, input will be passed into colormap()
%   colorLimits - optional, sets the colorbar limits

arguments
    long (1,:)
    lat (1,:)
    data = zeros(size(lat))'
    colorscheme = turbo
    colorLimits = 0; % [0 110] are good speed limits
end

% Code adapted from 
% https://www.mathworks.com/matlabcentral/answers/5042-how-do-i-vary-color-along-a-2d-line
x = long;
y = lat;
z = data'; % invert with ' to make it one row instead of col
color = data';  % This is the color, vary with data in this case. inverted
surface([x;x],[y;y],[z;z],[color;color],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',1);
colorbar;
if colorLimits ~= 0
    clim(colorLimits)
end
colormap(colorscheme);

% Unfortunately, there is no color gradient workaround for geoplots (that 
% I know of), but if you just want a to-scale track map use this command
% instead:
% geoplot(lat, long);

end