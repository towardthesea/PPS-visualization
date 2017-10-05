%% About 
% Script to visualize the parzen windown estimation of 1 taxel
% Author: NGUYEN Dong Hai Phuong
% Email: phuong.nguyen@iit.it; ph17dn@gmail.com

%%
clc;
clear all
close all

addpath('../');

SKIN_VERSION = 2; 

percRF = 1;

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
RFmax = percRF*cell2mat(RF(:, 3));

%%
numPts = 20;
d = (RFmax-RFmin)/numPts;
D = RFmin+d:d:RFmax;
xi = RFmin+d:d/10:RFmax;
j=1;
for i=1:1
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
%         subplot(2,2,mod(j,5));[f(i,:),x] = parzen_estimation(D,P(i,:),4*d,'r',figureTitle,1,[RFmin RFmax]);
        parzen_estimation(D,P(i,:),4*d,'r','',1,[RFmin RFmax],1);
        grid on
        filename = strcat('../results/pwe_',num2str(percRF),'.jpg')
        filenameeps = strcat('../results/pwe_',num2str(percRF),'.eps')
%         filename2 = sprintf('results/upperbodyPPS_%s_%0.2f_viewfront.jpg',DateTimeString,thrRF);
        print(fig(i), '-djpeg',filename);
        print(fig(i), '-depsc',filenameeps);
        

        j=j+1;
        if (j>4)
            j=1;
        end     
    end
end