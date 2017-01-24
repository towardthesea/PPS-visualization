%% About 
% Script to visualize the peripersonal space (PPS) representation of the upper body of iCub with the links of
% both arm and the head
% Using http://wiki.icub.org/wiki/ICubForwardKinematics (Created by Francesco Nori)
% Author: NGUYEN Dong Hai Phuong
% Email: phuong.nguyen@iit.it; ph17dn@gmail.com
% Contributions: Matej Hoffmann, matej.hoffmann@iit.it

%%
function out = main(varargin)

addpath(genpath('./ICubFwdKin/'));
addpath('./left_forearm');
addpath('./left_palm');
addpath('./right_forearm');
addpath('./right_palm');


close all
% clear all
clearvars -except varargin
clc
wtheta = [0, 0, 0]*pi/180;
htheta = [0, 0, 0, 0, -30, 30]*pi/180;
ratheta = [ -25.8  60.0     0.0     50    0.0   0.0  40.0]*pi/180;
latheta = [ -25.8  60.0     0.0     50    0.0   0.0  40.0]*pi/180;
rltheta = [0, 0, 0, 0, 0, 0]*pi/180;
lltheta = [0, 0, 0, 0, 0, 0]*pi/180;

prompt = 'Export PPS to files (Y/N)? \n';
export2files = input(prompt,'s');
EXPORT_TO_FILES = 0;
if (export2files == 'Y' || export2files == 'y')
    EXPORT_TO_FILES = 1;
    fprintf('Export PPS to files\n');
else
    fprintf('Do not export PPS to files\n');
end

if (length(varargin)>=2)
    thrRF = varargin{1}
    SKIN_VERSION = varargin{2}
elseif (length(varargin)>=1)
    thrRF = varargin{1}
    SKIN_VERSION = 2
elseif (isempty(varargin))
    thrRF = 0.0
    SKIN_VERSION = 2
end
clear varargin;

% cd WaistHeadFwdKin;
for i=1:length(thrRF)
    fig = figure(1);

    hold on;
    WaistHeadFwdKin(wtheta,htheta, 1);

    hold on;
    WaistInertiaFwdKin(wtheta,htheta(1:3), 1);

    hold on;
    [T_Ro0_r, T_0n_r, J_r, G_sL8_r, G_sL10_r] = WaistRightArmFwdKin(wtheta,ratheta, 1);
    hold on;
    [T_Ro0_l, T_0n_l, J_l, G_sL8_l, G_sL10_l] = WaistLeftArmFwdKin(wtheta,latheta, 1);



    % parameters for following plot functions: <ppsPlot_bodypart_func(...)>
    % param1: fig - figure name to plot on
    % param2: matT - RoF of the Receptive Field (RF)
    % param3: newRF - boolean to choose the new/old type of RF, 1 for new
    % param4: thrRF - threshold for the RF, 0 for whole, 1 for nothing

    ppsPlot_rightForearm_func(fig,G_sL8_r,1,thrRF(i),SKIN_VERSION);
    %ppsPlot_rightPalm_func(fig,G_sL10_r,1,thrRF(i),SKIN_VERSION);

    ppsPlot_leftForearm_func(fig,G_sL8_l,1,thrRF(i),SKIN_VERSION);
    %ppsPlot_leftPalm_func(fig,G_sL10_l,1,thrRF(i),SKIN_VERSION);

    hold off;
    colormap(fig,autumn);

    titleString = strcat('PPS visualization for iCub upper body with thrRF = ',num2str(thrRF(i)));
    title(titleString);
    xlim([-0.8 0.4]);
    ylim([-0.9 0.9]);
    zlim([-0.5 0.8]);
    view(2);
    caxis([-1 0]);

    cbh=colorbar;
    set(cbh,'YTick',-1:.1:0);
    % set(cbh,'YDir','reverse');
    set(cbh,'YTickLabel',{'1','0.9','0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1','0'})


    xlabel('x(m)','FontSize',14);    
    ylabel('y(m)','FontSize',14);    
    zlabel('z(m)','FontSize',14);

    if (EXPORT_TO_FILES)
        DateTimeString = datestr(now,30);   % Time format: (ISO 8601)  'yyyymmddTHHMMSS'

        set(gcf, 'Position', get(0, 'Screensize'));
        filename1 = strcat('results/upperbodyPPS_',DateTimeString,'_',num2str(thrRF(i)),'_viewtop.jpg')
        filename  = strcat('results/upperbodyPPS_',DateTimeString,'_',num2str(thrRF(i)),'.fig');
        print(fig, '-djpeg',filename1);
        saveas(fig,filename)
    %     filename = sprintf('upperbodyPPS_view2.pdf');
    %     print(fig, '-dpdf', '-bestfit',filename);

        view ([-pi/2 0 0])

        set(gcf, 'Position', get(0, 'Screensize'));
        filename2 = strcat('results/upperbodyPPS_',DateTimeString,'_',num2str(thrRF(i)),'_viewfront.jpg')
%         filename2 = sprintf('results/upperbodyPPS_%s_%0.2f_viewfront.jpg',DateTimeString,thrRF);
        print(fig, '-djpeg',filename2);
%         saveas(fig, filename2);
        
%         clear filename filename1 fig
        clearvars -except wtheta htheta ratheta latheta thrRF i EXPORT_TO_FILES
        close all       

    end
    
end


end
