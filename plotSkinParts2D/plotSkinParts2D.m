% plotting is based on plotTaxelsPOSUNUTE, but copied here, so I can label
% and save figs

clc;clear;

SAVE_FIGURES = true; 
PLOT_TORSO_UPPER = false;

%%load data
load('./taxel_pos_zdenek/taxPosTorso.mat');
Mtorso = M;
M = [];

load('./taxel_pos_zdenek/rUpperarmTaxPos.mat');
MupperArmR = M;
M = [];

load('./taxel_pos_zdenek/rForearmTaxPos.mat');
MforearmR = rForearmTaxPos;
M = []; rForearmTaxPos = [];

load('../right_palm/taxel_positions_with_IDs_right_palm_Marco.mat');
MpalmR = TAXEL_IDS_AND_POSITIONS;
MpalmR = MpalmR';


%% plot 
if PLOT_TORSO_UPPER
    f1 = figure(1);
    clf(f1);
    title('Taxel IDs - torso like skinGui');
    %plotTaxelsPOSUNUTE(Mtorso,'capt');
    axis equal;
    hold on;
    for i=1:1:size(Mtorso,2)
        if not(Mtorso(3,i)==0)
            plot(Mtorso(1,i),Mtorso(2,i),'oy');
        end
    end
    for i=1:1:size(Mtorso,2)
        if not(Mtorso(3,i)==0)
            text(Mtorso(1,i),Mtorso(2,i),int2str(i-1),'fontSize',10,'fontWeight','bold')
        end
    end

    f2 = figure(2);
    clf(f2);
    title('Taxel IDs - right upper arm like skinGui');
    %plotTaxelsPOSUNUTE(MupperArmR,'capt');
    axis equal;
    hold on;
    for i=1:1:size(MupperArmR,2)
        if not(MupperArmR(3,i)==0)
            plot(MupperArmR(1,i),MupperArmR(2,i),'oy');
        end
    end
    for i=1:1:size(MupperArmR,2)
        if not(MupperArmR(3,i)==0)
            text(MupperArmR(1,i),MupperArmR(2,i),int2str(i-1),'fontSize',10,'fontWeight','bold')
        end
    end
end

%% forearm
supertaxel = [3 15 27 39 51 63 75 87 99 111 123 135 147 159 171 183 207 255 291 303 315 339 351];
f3 = figure(3);
clf(f3);
% title('Taxel IDs - right forearm like skinGui');
%plotTaxelsPOSUNUTE(MforearmR,'capt');
axis equal;
hold on;
for i=1:1:size(MforearmR,2)
    if not(MforearmR(3,i)==0)
        plot(MforearmR(1,i),MforearmR(2,i),'oy', 'markerSize',1);
        if sum(supertaxel==(i-1))==1%(i-1)==3
            plot(MforearmR(1,i)+2,MforearmR(2,i),'ob', 'markerSize',25, 'lineWidth',2);
        end
    end
end
% hold on;
for i=1:1:size(MforearmR,2)
    if not(MforearmR(3,i)==0)
        %text(MforearmR(1,i),MforearmR(2,i),int2str(i-1),'fontSize',10,'fontWeight','bold')
        text(MforearmR(1,i),MforearmR(2,i),sprintf('%3i',i-1),'fontSize',10,'fontWeight','bold')
    end
end
set(gcf, 'Position', get(0, 'Screensize'));
axis off;

%% palm
supertaxel = [3 15 27 39 51 101 103 118 124 137];
% palmIDs = [96 97 98 99 100 101 102 103 104 105 106 ]
finger_length = 15;
MfingerR = [ 3, MpalmR(2,27), MpalmR(3,27)+finger_length;
            15, MpalmR(2,32), MpalmR(3,32)+finger_length;
            27, MpalmR(2,4), MpalmR(3,4)+finger_length;
            39, MpalmR(2,1), MpalmR(3,1)+finger_length;
            51, MpalmR(2,48)+finger_length, MpalmR(3,48)];
MfingerR = MfingerR';
f4 = figure(4);
clf(f4);
% title('Taxel IDs - right forearm like skinGui');
%plotTaxelsPOSUNUTE(MforearmR,'capt');
axis equal;
hold on;
for i=1:1:size(MpalmR,2)
        plot(MpalmR(2,i),MpalmR(3,i),'oy', 'markerSize',1);
        if sum(supertaxel==(i+96-1))==1%(i-1)==3
            plot(MpalmR(2,i)+1,MpalmR(3,i),'ob', 'markerSize',25, 'lineWidth',2);
        end
end
% hold on;
for i=1:1:size(MpalmR,2)
        %text(MforearmR(1,i),MforearmR(2,i),int2str(i-1),'fontSize',10,'fontWeight','bold')
        text(MpalmR(2,i),MpalmR(3,i),sprintf('%3i',96+i-1),'fontSize',10,'fontWeight','bold')
end
% fingers
for i=1:1:size(MfingerR,2)
        plot(MfingerR(2,i),MfingerR(3,i),'oy', 'markerSize',1);
        if sum(supertaxel==MfingerR(1,i))==1%(i-1)==3
            plot(MfingerR(2,i)+1,MfingerR(3,i),'ob', 'markerSize',25, 'lineWidth',2);
        end
end
% hold on;
for i=1:1:size(MfingerR,2)
        %text(MforearmR(1,i),MforearmR(2,i),int2str(i-1),'fontSize',10,'fontWeight','bold')
        text(MfingerR(2,i),MfingerR(3,i),sprintf('%3i',MfingerR(1,i)),'fontSize',10,'fontWeight','bold')
end
set(gcf, 'Position', get(0, 'Screensize'));
axis off;


%% saving

if SAVE_FIGURES
    if PLOT_TORSO_UPPER
        saveas(f1,'TaxelIDs_torso_likeSkinGui.fig');
        print -f1 -djpeg 'TaxelIDs_torso_likeSkinGui.jpg';
        saveas(f2,'TaxelIDs_rightUpperArm_likeSkinGui.fig');
        print -f2 -djpeg 'TaxelIDs_rightUpperArm_likeSkinGui.jpg';
    end
    saveas(f3,'TaxelIDs_rightForearm_likeSkinGui.fig');
    print -f3 -djpeg 'TaxelIDs_rightForearm_likeSkinGui.jpg';
    print(f3,'-depsc','TaxelIDs_rightForearm_likeSkinGui.eps');

    saveas(f4,'TaxelIDs_rightHand_likeSkinGui.fig');
    print -f4 -djpeg 'TaxelIDs_rightHand_likeSkinGui.jpg';
    print(f4,'-depsc','TaxelIDs_rightHand_likeSkinGui.eps');
end


