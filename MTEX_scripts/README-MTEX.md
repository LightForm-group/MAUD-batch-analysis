MTEX Plotter
-----------

MTEX scripts for the batch processing of orientation distribution function (ODF) data written in text format. The scripts can be used for the automated analysis of alpha and beta phase crystallographic texture, plotting of pole figures, plotting of ODFs and calculation of texture strength values. 

The analysis folder will need to contain a number of different .txt files, recording the ODF.

Contents
-----------
    
1. `MAUD_batch_MTEX_texture_plotter.m` A script for batch processing of ODF data, to calculate texture, plot pole figures, plot ODFs and calculate texture strength values. It can currently be used for both alpha and beta phases in titanium alloys. But, it could easily be adapted for any phase in a crystal material.

MATLAB Setup
-----------

The scripts have been tested with MATLAB Version R2019b.

MTEX Installation
-----------

The MTEX toolbox can be downloaded from [here](https://mtex-toolbox.github.io/download), which also includes instructions for installing MTEX and troubleshooting any issues.

The scripts have been tested with MTEX Version 5.1.0, 5.2.8, and 5.3.0, but should only require minor adjustments to work with future versions.

Some minor changes to the base MTEX code have been made to produce better looking figures. See [here](https://lightform-group.github.io/wiki/software_and_simulation/mtex-nice-figures) for more information.
