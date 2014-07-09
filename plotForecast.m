function [] = plotForecast(DATES, ACTUAL, varargin)
%PLOTFORECAST Linear plot
%   varargin - P0, S0, P1, S1, ... - Prediction load and style

dateFormat = 'dd';
[m, n] = size(ACTUAL);
actual = ACTUAL';
actual = actual(:);
% Make dates by the hour
dates = DATES;
dates = repmat(dates,24,1);
dates = sortrows(dates,3);
dates = sortrows(dates,2);
dates = sortrows(dates,1);
years = dates(:,1);
months = dates(:,2);
days = dates(:,3);
hours = 0:23;
hours = hours(:);
hours = repmat(hours,m,1);
x = datenum(years,months,days,hours,zeros(length(hours),1),zeros(length(hours),1));
extra = size(varargin,2)/2;
v = cell(1, size(varargin,2)+extra);
j =1;
for i = 1:3:size(v,2)
    v{i} = x;
    y = varargin{j}';
    y = y(:);
    v{i+1} = y;
    v{i+2} = varargin{j+1};
    j = j + 2;
end
plot(x,actual,'k',v{:});
datetick2;
end