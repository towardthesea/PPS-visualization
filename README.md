PPS-Visualization
=============================
The repository provides Matlab scripts and functions to handle mainly visualization-related things of the peripersonal space (PPS) representation of the iCub humanoid robot.

PPS in iCub is provided by this module: [peripersonal-space] (https://github.com/robotology/peripersonal-space)

## Table of contents
1. [Main PPS visualization](#main-pps-visualization)
2. [Individual body part PPS visualization](#individual-body-part-pps-visualization)
3. [Perfect PPS generation](#perfect-pps-generation)
4. [Receptive field formulation and visualization](#receptive-field-formulation-and-visualization)
5. [How to](#how-to)


## Main PPS visualization

Please run the command in the same folder or add the path of the folder before running [**main**](https://github.com/towardthesea/PPS-visualization/blob/master/main.m) to visualize the whole upper body PPS as shown in figures:
 - Front view (percRF(right,left) = (0.25, 0.5)):
	<img src="https://github.com/towardthesea/PPS-visualization/blob/master/misc/upperbodyPPS_viewfront.jpg"/>
 - Top view (percRF(right,left) = (0.25, 0.5)):
	<img src="https://github.com/towardthesea/PPS-visualization/blob/master/misc/upperbodyPPS_viewtop.jpg"/>

This will visualize the PPS around all taxels of all the forearms and hands.

Main can optionally take up two parameters: `main(thrRF,SKIN_VERSION, percRF)` where
 - `thrRF` can be a number <0,1> or an array of up to 4 numbers. This is a threshold applied to the visualization of PPS of the skin parts. E.g., with `thrRF=0.9`, only those parts of the PPS with activations exceeding 0.9 will be visualized. Default: 0.0
 - `SKIN_VERSION` applies to forearm versions, so that the correct taxel positions are loaded. Default: 2
 - `percRF` can be a number <0,1> or an array of up to 2 numbers. This is to sink the RF of PPS.  
 
All files with learned / handcrafted represenations are stored in the `ppsTaxelsFiles` directory. The ones that are loaded and plotted are specified in the individual script files:
 - [ppsPlot_leftForearm_func.m](https://github.com/towardthesea/PPS-visualization/blob/master/left_forearm/ppsPlot_leftForearm_func.m#L14)
 - [ppsPlot_leftPalm_func.m](https://github.com/towardthesea/PPS-visualization/blob/master/left_palm/ppsPlot_leftPalm_func.m#L14)
 - [ppsPlot_rightForearm_func.m](https://github.com/towardthesea/PPS-visualization/blob/master/right_forearm/ppsPlot_rightForearm_func.m#L14)
- [ppsPlot_rightPalm_func.m](https://github.com/towardthesea/PPS-visualization/blob/master/right_palm/ppsPlot_rightPalm_func.m#L15)

## Individual body part PPS visualization 
Please refer to: 
- [ppsPlot_leftForearm.m](https://github.com/towardthesea/PPS-visualization/blob/master/left_forearm/ppsPlot_leftForearm.m)
- [ppsPlot_leftPalm.m](https://github.com/towardthesea/PPS-visualization/blob/master/left_palm/ppsPlot_leftPalm.m)
- [ppsPlot_rightForearm.m](https://github.com/towardthesea/PPS-visualization/blob/master/right_forearm/ppsPlot_rightForearm.m)
- [ppsPlot_rightPalm.m](https://github.com/towardthesea/PPS-visualization/blob/master/right_palm/ppsPlot_rightPalm.m)

## Perfect PPS generation
These scripts allow to generate (rather than learn) a handcrafted PPS .ini file - possibly a "perfect" representation.

The scripts are in the `perfectPPSgenerationScripts` folder.

Use this script to generate: [generatePerfectTaxelsFile.m](https://github.com/towardthesea/PPS-visualization/blob/master/perfectPPSgenerationScripts/generatePerfectTaxelsFile.m)  

The shape can be set for example here: [writeTaxelsFile_n.m](https://github.com/towardthesea/PPS-visualization/blob/master/perfectPPSgenerationScripts/writeTaxelsFile_n.m)

Note: currently, the "mapping" section generated is not correct and has to be replaced by hand.

## Receptive field formulation and visualization
The `maximumRF.m` script contains formulation and visualization of the spherical sector that forms the RF of individual taxels.

## How to
- Figure 4, HRI2018: run script [pwe_draw.m](https://github.com/towardthesea/PPS-visualization/blob/master/left_forearm/pwe_draw.m) without any arguments. This script also relates mainly to [parzen_estimation.m](https://github.com/towardthesea/PPS-visualization/blob/master/parzen_estimation.m)
- Figure 5, HRI2018: run script [main.m](https://github.com/towardthesea/PPS-visualization/blob/master/main.m):
```
main(0,2,[0.5, 1]) 
```

