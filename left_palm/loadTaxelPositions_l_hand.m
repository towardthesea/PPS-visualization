%% About 
% Script to load taxel position for visualize the PPS of the left palm of iCub
% Originally from 'plot_and_transform_taxels_left.m'
% Author: NGUYEN Dong Hai Phuong
% Email: phuong.nguyen@iit.it; ph17dn@gmail.com

%%

SAVE_FIGURES = false;
PRODUCE_OUTPUT_FILE = false;

%% load stuff
%load('taxel_positions_left_palm_Marco');
load('taxel_positions_with_IDs_left_palm_Marco');
% this loads the TAXEL_IDS_AND_POSITIONS variable which comes after preprocessing of the excel sheet from Marco Maggiali - MMSP_L.xlsx
% Only columns 1, 4 and  5  were taken, copied to
% MMSP_L_positions_sorted_by_taxel_number.xlsx and SORTED by taxel number
% column, The manually copied to a matlab variable TAXEL_IDS_AND_POSITIONS
% and saved.
% first column: taxel ID - this is only for the palm - for the skin ports, this is actually 8*12 + this ID, that is the first palm taxel should be 97th value on the port, with ID of 96 - see  
% /home/matej/programming/iCub/main/app/skinGui/conf/skinGui/left_hand_V2_1.ini
% 2nd column: "x" positions of taxels in mm
% 3rd column: "y" positions of taxels in mm
% these are in FoR_9 - the "second" wrist joint - if we swap the axes x and
% y, an, in x,y,z. if we add -16 to z - there is a shift in the z-axis from
% wrist to palm

NR_TAXELS = size(TAXEL_IDS_AND_POSITIONS,1);
TAXEL_ID_OFFSET_PALM_TO_HAND = 96;


%% FoR transformations

%1) add empty z column
taxel_positions_FoR_9 = [];
for i=1:NR_TAXELS;
    taxel_positions_FoR_9(i,1) = TAXEL_IDS_AND_POSITIONS(i,3); % swap x and y
    taxel_positions_FoR_9(i,2) = TAXEL_IDS_AND_POSITIONS(i,2);
    taxel_positions_FoR_9(i,3) = -16; % w.r.t wrist joint position, the palm skin is 16 mm more "up", which is -16 w.r.t FoR9 z-axis
end

% 2) transform to FoR_10 (palm)
% I ran /media/DATA/my_matlab/icub_kinematics/ICubFwdKinNew/WaistLeftArmFwdKin/WaistLeftArmFwdKin_asScript.m
% to get the rototrans. matrix from FoR9 (second wrist joint) to FoR10
% (palm) --  G_910 in workspace (for zero joint angles theta)
% 

G_910 = [1.0000         0         0   62.5000;
         0    1.0000         0         0;
         0         0    1.0000  -16.0000;
         0         0         0    1.0000];
% this is in fact just a translation - so I could also do it without the whole rototranslation matrix, but let's keep it     
G_910_inv = inv(G_910); % to remap the coordinates, we need to use the inverse matrix       

taxel_positions_FoR_10=[];
taxel_positions_FoR_10_doublecheck=[];
for j=1:NR_TAXELS
    
   row_vector_9 = []; row_vector_10 = [];
   column_vector_homo_9=[]; column_vector_homo_10=[];
    
   row_vector_9 = taxel_positions_FoR_9(j,:);
   column_vector_homo_9 = row_vector_9';
   column_vector_homo_9(4)=1;
   column_vector_homo_10 = G_910_inv * column_vector_homo_9;
   column_vector_homo_10(4)=[];
   row_vector_10 = column_vector_homo_10';
   taxel_positions_FoR_10(j,:)=row_vector_10;
   
   
   %for doublechecking we do the translations manually 
   taxel_positions_FoR_10_doublecheck(j,1) = taxel_positions_FoR_9(j,1)-62.5;
   taxel_positions_FoR_10_doublecheck(j,2) = taxel_positions_FoR_9(j,2);
   taxel_positions_FoR_10_doublecheck(j,3) = taxel_positions_FoR_9(j,3)+16;
   
   if (~ isequal(taxel_positions_FoR_10,taxel_positions_FoR_10_doublecheck))
       disp('Transformed arrays are not equal!');
   end
  
   
end
       