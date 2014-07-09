clearvars;
loadHistoryFile = 'Load_history.csv';
numZones = 20;
load = cell(1,numZones);
for i = 1:numZones
    l = importZone(i, loadHistoryFile);
    [l.normalized, l.mu, l.sigma] = normalizeFeatures(l.data);
    l.hourly = hourlyForecast(l.normalized);
    l.hourly = unnormalizeFeatures(l.hourly, l.mu, l.sigma);
    l.daily = dailyForecast(l.normalized);
    l.daily = unnormalizeFeatures(l.daily, l.mu, l.sigma);
    load{i} = l;
end
clearvars l;
%%
pred = cell(1,21);
z21.data = 0;
for i = 1:numZones
    l = load{i};
    p = all(isnan(l.data),2);
    m = sum(p);
    zone = repmat(i,m,1);
    data = l.hourly(p,:);
    pred{i} = [zone, l.dates(p,:), data];
    z21.data = z21.data + data;
end
zone = repmat(21,m,1);
pred{21} = [zone,l.dates(p,:),z21.data];
%% Squash all predictions
submission = [];
for i = 1:length(pred)
    submission = [submission;pred{i}];
end
submission = sortrows(submission,1);
submission = sortrows(submission,4);
submission = sortrows(submission,3);
submission = sortrows(submission,2);