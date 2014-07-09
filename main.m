clear ; close all; clc

loadHistoryFile = 'Load_history.csv';
while true
zone = input('Pick a zone (1-20), or 0 to quit: ');
if(zone == 0)
    break;
end
while (zone < 0 || zone > 20)
    zone = input('Pick a zone (1-20), or 0 to quit: ');
    continue;
end
t = input('Pick a type of prediction hourly (h) or daily (d): ','s');
while t ~= 'd' && t ~= 'h'
    t = input('Please pick from hourly (h), or daily (d): ', 's');
end

load = importZone(zone, loadHistoryFile);
[load.normal, load.mu, load.sigma] = normalizeFeatures(load.data);
if t == 'd'
    load.prediction = dailyForecast(load.normal);
    type = 'Daily';
else 
    load.prediction = hourlyForecast(load.normal);
    type = 'Hourly';
end
if isequal(load.prediction,[]) % failed forecast
    fprintf('Forecast failed.\n');
    continue;
end
load.prediction = unnormalizeFeatures(load.prediction,load.mu,load.sigma);
plotForecast(load.dates,load.data,load.prediction,'r');
mainTitle = sprintf('Zone %d - %s Load Forecast', zone, type);
title(mainTitle);
ylabel('Load(kW)');
xlabel('Date/Hour');
legend('Actual', 'Prediction');
fprintf('MAPE: %f\n', mape(load.data(:),load.prediction(:)));
fprintf('SMAPE: %f\n', smape(load.data(:),load.prediction(:)));
end