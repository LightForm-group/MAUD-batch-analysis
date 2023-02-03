MAUD-batch-analysis
-----------

A series of Python scripts to facilitate working with [Materials Analysis Using Diffraction, MAUD](http://maud.radiographema.eu) in a batch analysis mode, for analysis of large synchrotron X-ray diffraction (SXRD) pattern image datasets.

MAUD's batch analysis mode can be used to extract material properties from a series of synchrotron diffraction pattern images. In particular, this package is focused on refining and extracting crystallographic texture for multiple phases from a series of diffraction pattern images, using MAUD's in-built E-WIMV texture refinement algorithm.

This package has been tested using MAUD Version 2.78 on Mac OS Monterey. MAUD batch mode has been tested using two different experimental datasets (from Diamond Light Source Ltd. in 2017 and in 2021). The data, analysis and results files for these experiments can be downloaded from a [Zenodo release](https://doi.org/10.5281/zenodo.7602926) to accompany this package and to demonstrate MAUD batch mode.

Following successful completion of a MAUD batch mode analysis, the texture is extracted as an orientation distribution function (ODF) in the form of a text file using a Python script.

The package includes a separate folder of MTEX scripts, in MATLAB, for automatic analysis and plotting of the ODF slices, calculate texture intensity values and plot pole figures. More details about the setup of MTEX can be found in MTEX-scripts/README-MTEX.md

Development
--------------

This package was developed by Christopher S. Daniel at The 
University of Manchester, UK, and was funded by the Engineering and Physical Sciences Research Council (EPSRC) via the LightForm programme grant (EP/R001715/1). LightForm is a 5 year multidisciplinary project, led by The Manchester University with partners at University of Cambridge and Imperial College, London (https://lightform.org.uk/).

Contents
-----------

**It is recommended the user works through the example notebooks in the following order:**
    
1. `python_notebooks/MAUD Batch Mode Setup.ipynb` A notebook for setting up and running MAUD in batch mode.

2. `python_notebooks/MAUD Batch Mode Analysis.ipynb` A notebook for analysing the results of MAUD batch mode and for extracting crystallographic texture in the form of an ODF in text format.

3. `python_notebooks/MAUD Batch Mode Analysis - Minimise Error.ipynb` A notebook for minimising the error of the Rietveld refinement in MAUD, by testing different refinement iterations.

*Note, the `example-data/` and `example-analysis/` folders contain instuctions for downloading data that can be used as an example analysis, but a clear external file structure should be setup to support the analysis of large synchrotron datasets.*

Installation and Virtual Environment Setup
-----------

Follow along by copying / pasting the commands below into your terminal (for a guide on using a python virtual environments follow steps 4-7).

**1. First, you'll need to download the repository to your PC. Open a unix command line on your PC and navigate to your Desktop (or GitHub repository):**
```unix
cd ~/Desktop
```
**2. In your teminal, use the following command to clone this repository to your Desktop:**
```unix
git clone https://github.com/LightForm-group/MAUD-batch-analysis.git
```
**3. Navigate inside `Desktop/MAUD-batch-analysis/` and list the contents using `ls`(macOS) or `dir`(windows):**
```unix
cd ~/Desktop/MAUD-batch-analysis/
```
**4. Next, create a python virtual environment (venv) which contains all of the python libraries required to use MAUD-batch-analysis.
Firstly, use the following command to create the venv directory which will contain the necessary libraries:**
```unix
python -m venv ~/Desktop/MAUD-batch-analysis/venv
```
**5. Your `MAUD-batch-analysis/` directory should now contain `venv/`. Install the relevant libraries to this venv by first activating the venv:**
```unix
source ~/Desktop/MAUD-batch-analysis/venv/bin/activate
```
*Note, the beginning of your command line should change from `(base)` to include `(venv)`.*

**6. Install the python libraries to this virtual environment using pip and the `requirements.txt` file included within the repository:**
```unix
pip install -r ~/Desktop/MAUD-batch-analysis/requirements.txt
```
**7. To ensure these installed correctly, use the command `pip list` and ensure the following packages are installed:**
```unix
pip list
# Check to ensure that all of the following are listed:
#jupyter
#pathlib
#re
#tqdm
#numpy
#matplotlib
#pyyaml
```
**8. If all in step 7 are present, you can now run the example notebooks.
Ensure the venv is active and use the following command to boot jupyter notebook (using all libraries installed in the venv).
Warning - using just `jupyter notebook` without `python -m` can result in using your default python environment (the libraries may not be recognised):**
```unix
python -m jupyter notebook
```
**9. Work through the notebooks and setup yaml text files for somewhat reproducible MAUD batch analyses of large synchrotron datasets.**

**10. When you're finished using the virtual environment, deactivate it!
This will avoid confusion when using different python libraries that are not installed within the virtual environment:**
```unix
deactivate
```

Required Libraries
--------------------

The required libraries are listed in requirements.txt