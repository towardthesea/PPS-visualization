%% About 
% Script to visualize the PPS of the left forearm of iCub
% Author: NGUYEN Dong Hai Phuong
% Email: phuong.nguyen@iit.it; ph17dn@gmail.com

%%
clc;
clear all
close all

addpath('../');

SKIN_VERSION = 2; 

printToFile = 0;

%% Initialize variables.
%filename = 'taxels1D_learned_l_forearm.ini'
%filename = 'taxels1D_45cmRF_skinV2_learned_l_forearm.ini'
filename = '../ppsTaxelsFiles/taxels1D_45cmRF_skinV2_perfect_l_forearm.ini'
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

%% Check the RF range
startRow = 5;
endRow = 5;
formatSpec = '%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataRF = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow-1, 'ReturnOnError', false);
fclose(fileID);
RF = repmat({''},length(dataRF{1}),length(dataRF)-1);
for col=1:length(dataRF)-1
    RF(1:length(dataRF{col}),col) = dataRF{col};
end
numericData = NaN(size(dataRF{1},1),size(dataRF,2));

for col=[1,2,3]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawRF = dataRF{col};
    for row=1:size(rawRF, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawRF{row}, regexstr, 'names');
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
                RF{row, col} = numbers{1};
            end
        catch me
        end
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),RF); % Find non-numeric cells
RF(R) = {NaN}; % Replace non-numeric cells
RFmin = cell2mat(RF(:, 2));
RFmax = cell2mat(RF(:, 3));

%%
numPts = 20;
d = (RFmax-RFmin)/numPts;
D = RFmin+d:d:RFmax;
xi = RFmin+d:d/10:RFmax;
j=1;
for i=1:length(l_forearm)
    values(i,1:length(raw)-1) = cell2mat(raw(i,2:length(raw)));
    p(i,1:(length(raw)-1)/2) = values(i,1:(length(raw)-1)/2);
    n(i,1:(length(raw)-1)/2) = values(i,(length(raw)-1)/2+1:(length(raw)-1));
    
    % Remove the component equal to NaN
    pn = p(i,:) + n(i,:);
    idZero = find(pn==0 & p(i,:)==0);
%     P(i,1:(length(raw)-1)/2) = values(i,1:(length(raw)-1)/2)./values(i,(length(raw)-1)/2+1:(length(raw)-1));
    P(i,1:(length(raw)-1)/2)= p(i,:)./(n(i,:)+p(i,:));
    P(i,idZero) = 0;
    %===================================

    if (any(p(i,:)~=0))
        if (mod(j,4)==1)
            fig(i) = figure; 
            set(fig(i),'Position',[50 50 1200 800]);
            set(fig(i),'PaperOrientation','landscape');
        end
        figureTitle = sprintf('Taxel %ith',l_forearm(i));
        subplot(2,2,mod(j,5));[f(i,:),x] = parzen_estimation(D,P(i,:),4*d,'r',figureTitle,1,[RFmin RFmax]);
        grid on
        j=j+1;
        if (j>4)
            j=1;
        end
        
%         
    end
end

%% Print pdf file
if (printToFile)    
    j=1;
    for i=1:length(fig)
        if (isgraphics(fig(i)))
            filename = sprintf('figure%i.pdf',j);
            %print(fig(i), '-dpdf', '-bestfit',filename);
            print(fig(i), '-dpdf', filename);
            j=j+1;
        end

    end
end

%% Load taxel files
if SKIN_VERSION == 1
    load left_forearm_taxel_pos_mesh.mat; % the no_mesh is also possible, but there are no normals, so you can't overlay the triangular modules
    taxel_pos = left_forearm_taxel_pos_mesh; 
elseif SKIN_VERSION == 2
    load leftForearmV2.mat; 
    taxel_pos = leftforearmV2noHeader;     
else
    error('Unknown skin version');
end
[M,N] = size(taxel_pos);
   
pos0 = taxel_pos;

%% Transform
matT=  [1 0 0 0;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];

posOrigin = matT(1:3,4)';
        
%% Plot whole PPS 
figure; hold on
title('Positions of left foreram taxels (in 1st wrist FoR - FoR_8)');
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
                h = hist_map3d([taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3)],-sign(j-192.5)*x,-f(i,:));
                
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

h = quiver3(posOrigin(1),posOrigin(2),posOrigin(3),lNorm,0,0);
set(h, 'Color', 'r', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on');
text(posOrigin(1)+lNorm,posOrigin(2),posOrigin(3),'x');
h2 = quiver3(posOrigin(1),posOrigin(2),posOrigin(3), 0,lNorm,0);
set(h2, 'Color', 'g', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on')
text(posOrigin(1),posOrigin(2)+lNorm,posOrigin(3),'y');
h3 = quiver3(posOrigin(1),posOrigin(2),posOrigin(3), 0,0,lNorm);
set(h3, 'Color', 'b', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on')
text(posOrigin(1),posOrigin(2),posOrigin(3)+lNorm,'z');

xlabel('Taxel position x (m)');
set(gca,'XDir','reverse');
ylabel('Taxel position y (m)');
zlabel('Taxel position z (m)');
set(gca,'ZDir','reverse');
hold off; grid on;

%% Transform
matT=  [1 0 0 0;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];

for i=1:M
    pos1(i,:) = matT(1:3,4)+matT(1:3,1:3)*taxel_pos(i,1:3)';
    pos0n(i,:)= taxel_pos(i,4:6)+taxel_pos(i,1:3);
    pos1n(i,:)= matT(1:3,4)+matT(1:3,1:3)*pos0n(i,:)';
    taxel_pos(i,1:3) = pos1(i,:)';
    taxel_pos(i,4:6) = pos1n(i,:)' - pos1(i,:)';
end

posOrigin = matT(1:3,4)';

%% Plot whole PPS

figure;
hold on
title('PPS of left foreram taxels (in 1st wrist FoR - FoR_8)');
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
                h = hist_map3d([taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3)],-sign(j-192.5)*x(59:end),-f(i,59:end),100,1);
                          
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

h = quiver3(posOrigin(1),posOrigin(2),posOrigin(3),lNorm,0,0);
set(h, 'Color', 'r', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on');
text(posOrigin(1)+lNorm,posOrigin(2),posOrigin(3),'x');
h2 = quiver3(posOrigin(1),posOrigin(2),posOrigin(3), 0,lNorm,0);
set(h2, 'Color', 'g', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on')
text(posOrigin(1),posOrigin(2)+lNorm,posOrigin(3),'y');
h3 = quiver3(posOrigin(1),posOrigin(2),posOrigin(3), 0,0,lNorm);
set(h3, 'Color', 'b', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on')
text(posOrigin(1),posOrigin(2),posOrigin(3)+lNorm,'z');

xlabel('Taxel position x (m)');
set(gca,'XDir','reverse');
ylabel('Taxel position y (m)');
zlabel('Taxel position z (m)');
set(gca,'ZDir','reverse');
hold off; grid on;

cbh=colorbar;
% set(cbh,'YTick',-1:.1:0);
set(cbh,'YDir','reverse');
set(cbh,'YTickLabel',{'1','0.9','0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1','0'})


%% Plot PPS on lower patch
figure; hold on
title('Positions of left foreram taxels with their IDs - lower patch (in 1st wrist FoR - FoR_8)');


for i=1:length(l_forearm)
    if (any(f(i,:)~=0))
        for j=1:192
            if (l_forearm(i)==j)
                hist_map3d([taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3)],x,f(i,:));
                text(taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3),int2str(j-1),'Color','r'); 
            end
        end
    end
end

h = quiver3(0 ,0.05, 0,0.05,0,0);
set(h, 'Color', 'r', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on');
text(0.01,0.05,0,'x');
h2 = quiver3(0,0.05, 0,0,0.05,0);
set(h2, 'Color', 'g', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on')
text(0,0.06,0,'y');
h3 = quiver3(0,0.05, 0,0,0,0.05);
set(h3, 'Color', 'b', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on')
text(0,0.05,0.01,'z');

xlabel('Taxel position x (m)');
set(gca,'XDir','reverse');
ylabel('Taxel position y (m)');
zlabel('Taxel position z (m)');
set(gca,'ZDir','reverse');

hold off; grid on;


%% Plot PPS on upper patch
figure; hold on
title('Positions of left foreram taxels with their IDs - upper patch (in 1st wrist FoR - FoR_8)');

for i=1:length(l_forearm)
    if (any(f(i,:)~=0))
        for j=193:M
            if (l_forearm(i)==j)
                hist_map3d([taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3)],-x,f(i,:));
                text(taxel_pos(j,1),taxel_pos(j,2),taxel_pos(j,3),int2str(j-1),'Color','r'); 

            end
        end
    end
end

h = quiver3(0 ,0.05, 0,0.05,0,0);
set(h, 'Color', 'r', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on');
text(0.01,0.05,0,'x');
h2 = quiver3(0,0.05, 0,0,0.05,0);
set(h2, 'Color', 'g', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on')
text(0,0.06,0,'y');
h3 = quiver3(0,0.05, 0,0,0,0.05);
set(h3, 'Color', 'b', 'LineWidth', 2, 'MaxHeadSize', 4, 'ShowArrowHead', 'on')
text(0,0.05,0.01,'z');

xlabel('Taxel position x (m)');
set(gca,'XDir','reverse');
ylabel('Taxel position y (m)');
zlabel('Taxel position z (m)');
% set(gca,'ZDir','reverse');
% axis equal;
hold off; grid on;

%% Clear temporary variables
% clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me;
% end