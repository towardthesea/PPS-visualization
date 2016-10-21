%% About 
% Script to visualize the PPS of the left forearm of iCub
% Author: NGUYEN Dong Hai Phuong
% Email: phuong.nguyen@iit.it; ph17dn@gmail.com

%%
function hAxes = ppsPlot_leftForearm_func(varargin)

printToFile = 0;

%% Initialize variables.
filename = 'taxels1D_learned_l_forearm.ini'
delimiter = {' ','(',')'};
startRow = 8;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Exclude columns with non-numeric cells
I = ~all(cellfun(@(x) (isnumeric(x) || islogical(x)) && ~isnan(x),raw),1); % Find columns with non-numeric cells
raw(:,I) = [];

%% Initialize column outputs.
columnIndices = cumsum(~I);

%% Allocate imported array to column variable names
if ~I(1)
    l_forearm = cell2mat(raw(:, columnIndices(1)));
end

%%
numPts = 20;
d = .3/numPts;
D = -.1:d:.2-d;
xi = -.1:d/10:.2-d;
j=1;
for i=1:length(l_forearm)
    values(i,1:length(raw)-1) = cell2mat(raw(i,2:length(raw)));
    p(i,1:(length(raw)-1)/2) = values(i,1:(length(raw)-1)/2);
    n(i,1:(length(raw)-1)/2) = values(i,(length(raw)-1)/2+1:(length(raw)-1));
    
    % Remove the component equal to NaN
    pn = p(i,:) + n(i,:);
    idZero = find(pn==0 & p(i,:)==0);
    P(i,1:(length(raw)-1)/2)= p(i,:)./(n(i,:)+p(i,:));
    P(i,idZero) = 0;
    %===================================
    if (any(p(i,:)~=0))
        figureTitle = sprintf('Taxel %ith',l_forearm(i));
        [f(i,:),x] = parzen_estimation(D,P(i,:),4*d,'r',figureTitle,0);
    end
end

%% Load taxel files
loadTaxelPositions;
pos0_l = taxel_pos;

%% Transform
matT=  [1 0 0 0;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];

if (~isempty(varargin))
    if (length(varargin)>=2)
        fig = varargin{1};
        matT = varargin{2};  
    elseif (length(varargin)>=1)
        fig = varargin{1};        
    end
else
    fig = figure;
end
for i=1:M
    pos1(i,:) = matT(1:3,4)+matT(1:3,1:3)*taxel_pos(i,1:3)';
    pos0n(i,:)= taxel_pos(i,4:6)+taxel_pos(i,1:3);
    pos1n(i,:)= matT(1:3,4)+matT(1:3,1:3)*pos0n(i,:)';
    taxel_pos(i,1:3) = pos1(i,:)';
    taxel_pos(i,4:6) = pos1n(i,:)' - pos1(i,:)';
end

posOrigin = matT(1:3,4)';
        
%% Plot whole PPS from 0->0.2m
figure(fig); hold on
title('PPS of left foreram taxels from 0->0.2m (in 1st wrist FoR - FoR_8)');
colormap autumn %flag hot

for i=1:M
    if (nnz(taxel_pos(i,:)) > 1) % it's not an all-zero row
        plot3(taxel_pos(i,1),taxel_pos(i,2),taxel_pos(i,3),'xb');
    end
end

lNorm = 0.05;
for i=1:length(l_forearm)
    if (any(f(i,:)~=0))
        for j=1:M
            if (l_forearm(i)==j)
                h = hist_map3d([taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3)],-sign(j-192.5)*x(70:end),-f(i,70:end));
                % -sign(j-192.5) is to differentiate between lower and
                % upper portion of forearm (from taxelID 193, the other
                % part starts) - different orientation
                % x(70:end) - to plot only the positive part of RF -
                % dependent on the number of bins 
                % revertign the signs for the heatmap -f(i,70:end)
                          
                v1 = [taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3)-sign(j-192.5)*.05];
                vz = [0 0 -sign(j-192.5)*.05];
                v2 = [taxel_pos(j,4),taxel_pos(j,5),taxel_pos(j,6)];
                n = cross(vz,v2);
                angle(j) = acos(dot(vz,v2)/(norm(vz)*norm(v2)));
                rotate(h,n,angle(j)/pi*180,taxel_pos(j,1:3));
                
                text(taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3),int2str(j-1),'Color','r'); 
                
                h = quiver3(taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3),lNorm*taxel_pos(j,4),lNorm*taxel_pos(j,5),lNorm*taxel_pos(j,6));
                set(h, 'Color', 'b', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on');
            end
        end
    end
end

xlabel('Taxel position x (m)');
ylabel('Taxel position y (m)');
zlabel('Taxel position z (m)');
hold off; grid on;
clear taxel_pos pos1 pos0_l

%% Clear temporary variables
% clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me;
end