PPS-Visualization
=============================
The repository provides Matlab scripts and functions to handle mainly visualization-related things of the peripersonal space (PPS) representation of the iCub humanoid robot.

PPS in iCub is provided by this module: [peripersonal-space] (https://github.com/robotology/peripersonal-space)

## Main PPS visualization

Please run the command in the same folder or add the path of the folder before running
	**main**: to visualize the whole upper body PPS as shown in figure
	<img src="https://github.com/towardthesea/PPS-visualization/blob/master/misc/upperbodyPPS.jpg"/>

This will visualize the PPS around all taxels of all the forearms and hands.

Main can optionally take up two parameters: `main(thrRF,SKIN_VERSION)` where
 - `thrRF` can be a number <0,1> or an array of up to 4 numbers. This is a threshold applied to the visualization of PPS of the skin parts. E.g., with `thrRF=0.9`, only those parts of the PPS with activations exceeding 0.9 will be visualized. Default: 0.0
 - `SKIN_VERSION` applies to forearm versions, so that the correct taxel positions are loaded. Default: 2
 
All files with learned / handcrafted represenations are stored in the `ppsTaxelsFiles` directory. The ones that are loaded and plotted are specified in the individual script files:
 - [ppsPlot_leftForearm_func.m](https://github.com/towardthesea/PPS-visualization/blob/master/left_forearm/ppsPlot_leftForearm_func.m#L14)
 - [ppsPlot_leftPalm_func.m](https://github.com/towardthesea/PPS-visualization/blob/master/left_palm/ppsPlot_leftPalm_func.m#L14)
 - [ppsPlot_rightForearm_func.m](https://github.com/towardthesea/PPS-visualization/blob/master/right_forearm/ppsPlot_rightForearm_func.m#L14)
- [ppsPlot_rightPalm_func.m](https://github.com/towardthesea/PPS-visualization/blob/master/right_palm/ppsPlot_rightPalm_func.m#L15)

## Invidual body part PPS visualization 
Please refer to: 
- [ppsPlot_leftForearm.m](https://github.com/towardthesea/PPS-visualization/blob/master/left_forearm/ppsPlot_leftForearm.m)
- [ppsPlot_leftPalm.m](https://github.com/towardthesea/PPS-visualization/blob/master/left_palm/ppsPlot_leftPalm.m)
- [ppsPlot_rightForearm.m](https://github.com/towardthesea/PPS-visualization/blob/master/right_forearm/ppsPlot_rightForearm.m)
- [ppsPlot_rightPalm.m](https://github.com/towardthesea/PPS-visualization/blob/master/right_palm/ppsPlot_rightPalm.m)

## Perfect (handcrafted) PPS generation
These scripts allow to generate (rather than learn) a handcrafted PPS .ini file - possibly a "perfect" representation.

The scripts are in the `perfectPPSgenerationScripts` folder.

Use this script to generate: [generatePerfectTaxelsFile.m](https://github.com/towardthesea/PPS-visualization/blob/master/perfectPPSgenerationScripts/generatePerfectTaxelsFile.m)
The shape can be set for example here: [writeTaxelsFile_n.m](https://github.com/towardthesea/PPS-visualization/blob/master/perfectPPSgenerationScripts/writeTaxelsFile_n.m)

Note: currently, the "mapping" section generated is not correct and has to be replaced by hand.

## Receptive field formulation and visualization
The `maximumRF.m` script contains formulation and visualization of the spherical sector that forms the RF of individual taxels.
