function [ LOAD ] = importZone(ZONE, LOADHISTORYFILE )
%IMPORTZONE Imports load histroy for a zone from file.
%   LOADHISTORYFILE format - 
%       zone_id	year	month	day	
%       h1	h2	h3	h4	h5 h6	h7	h8	h9	h10	h11	h12	
%       h13	h14	h15	h16	h17	h18	h19	h20	h21	h22	h23	h24
%   where h# represents the hour of the day

loadHistory = importdata(LOADHISTORYFILE);
load = loadHistory.data(loadHistory.data(:,1)==ZONE,:);

years = load(:,2);
months = load(:,3);
days = load(:,4);
LOAD.dates = [years,months,days];

LOAD.data = load(:,5:end);

end

