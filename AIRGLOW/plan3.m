lat = 18.3;
lon = -66.8;

load '/u/i/pb948/Documents/MATLAB/airglow/ml/arecibo_6300_2020_goodnight.mat' pernight

inFolder = '/data2/AIRGLOW/arecibo/6300/2020';
addpath('/data2/AIRGLOW/arecibo/6300/2020');
outFolder = '/data2/peter/alloverairglow/stransed/arecibo/';
outMaskFolder = '/data2/peter/alloverairglow/nooowaves/arecibo/';
%inFolder = '/u/i/pb948/Documents/MATLAB/airglow/arecibo';
%addpath('/u/i/pb948/Documents/MATLAB/airglow/arecibo');

%Get number of files in location folder
a = dir(fullfile(inFolder, '*.data.mat'));
n = numel(a);

%allST = struct('night', [], 'strans', []);


[xs, ys, G, latlony] = properregrid;
[latP, lonP] = reckon(lat, lon, latlony(1).arc, latlony(1).azimuth, latlony(1).sphere);

for nights = 1:n
    
    %Load in each night in turn
    load(a(nights).name)
    Airglow = double(Airglow);
    a(nights).name
    
    outy = pernight(nights).outy;
    
    n = 1;
    if isempty(outy(:,1)) == 1
        continue
    else
        value = outy(n,1);
        if value > 12
        	%allST(end+1).night = a(nights).name(1:9);
        	%allST(end).strans = struct('startTime', [], 'dt', [], 'ST', []);
            tempST = struct('startTime', [], 'dt', [], 'ST', []);
            %assignin('base', ['strans', a(nights).name(1:9)], struct('startTime', [], 'dt', [], 'ST', []));
        end
        while value > 12
            
            goodBits = Airglow(:,:,outy(n,2):outy(n,2)+value);
            tim = Times(outy(n,2):outy(n,2)+value);
            dt = seconds(datetime(tim(3), 'ConvertFrom', 'datenum')-datetime(tim(2), 'ConvertFrom', 'datenum'));
            ST = allDayTogetherFunc(goodBits, xs, ys, G, dt);
            tempST(n).startTime = Times(outy(n,2));
            tempST(n).dt = dt;
            tempST(n).ST = ST;
            %allST(end).strans(n).startTime = Times(idx(n));
            %allST(end).strans(n).dt = dt;
            %allST(end).strans(n).ST = ST;
            n = n+1;
            value = outy(n,1);            
        end
        assignin('base', ['strans', a(nights).name(1:9)], tempST);
        save ([outFolder, 'strans', a(nights).name(1:9)], [a(nights).name(1:9)])
        clear Airglow goodFrames badFrames consec out ii val value idx tempST
    end
end

howmany = noowaves(outFolder);
save(fullfile(outMaskFolder, 'howmany'), 'howmany')


%save allST_arecibo_6300_2020 allST
save geoInfoArecibo xs ys latP lonP