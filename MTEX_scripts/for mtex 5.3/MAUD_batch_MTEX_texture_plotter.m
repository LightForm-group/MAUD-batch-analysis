%% User Inputs...

%% Specify the Experiment Number

%experiment_number = '103845';
experiment_number = 'combined_103840-103845';
%experiment_number = '065';

%% Specify the Material

material = 'titanium';
%material = 'zirconium'

%% Specify ODF Resolution

odf_resolution = 15;

%% Specify Rotation (if required)

% 103845
% euler1 = 0;
% euler2 = 90;
% euler3 = 90;

% 103845 beta
euler1 = 0;
euler2 = 90;
euler3 = 0;

% 065 alpha
% euler1 = 90;
% euler2 = 90;
% euler3 = 0;

% 065 beta
% euler1 = 0;
% euler2 = 0;
% euler3 = 0;

%% Specify Specimen Symmetries

SS = specimenSymmetry('triclinic');

%% Specify the PF plotting convention and maxima and the ODF maxima

% plotting convention
setMTEXpref('xAxisDirection','north');
setMTEXpref('zAxisDirection','intoPlane');

pf_max = 3; % set the pole figure maxima 
contour_step = 0.25; % set the contouring of the pole figure

odf_max = 5; % set the ODF maxima

%% Specify whether figures are visible (will pop-up)

%visible = 'on';
visible = 'off';

%% Define the maximum possible misorientation for component analysis

misorientation = 5;

%% ... End of User Inputs

%% Select Input and Output Directories

inputDir = uigetdir; % gets input directory
inputFiles = dir(fullfile(inputDir,'ODF*.txt')); % gets all txt files in struct

outputDir = uigetdir; % gets output directory

%% Test for phase name in input folder directory (to set the crystal symmetry)
% note, change folder name to set the phase

str_alpha = 'alpha';
str_beta = 'beta';
test_alpha = strfind(inputDir,str_alpha);
test_beta = strfind(inputDir,str_beta);

if ~isempty(test_alpha);
    
    phase = 'alpha';
      
    if strcmp(material, 'titanium');
      % define alpha crystal symmetry
      CS = crystalSymmetry('6/mmm', [2.95 2.95 4.686], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Titanium-alpha', 'color', 'light blue');
    
    elseif strcmp(material, 'zirconium');
      % define alpha crystal symmetry
      CS = symmetry('6/mmm', [3.232 3.232 5.147], 'X||a*', 'Y||b', 'Z||c', 'mineral', 'Zirconium-alpha', 'color', 'light blue');
      
    else
        disp('Material input for alpha phase not recognised.');
        return;
    end
      
    % open a file to save the texture index values
    fileTI = fopen(fullfile(outputDir, strcat('texture_strength_alpha_', experiment_number, '.txt')),'w');
    fprintf(fileTI, 'Test Number \t Texture Index \t ODF Max \t phi1 Angle of ODF Max \t PHI Angle of ODF Max \t phi2 Angle of ODF Max \t {0002} PF Max \t {10-10} PF Max \t {11-20} PF Max \t Basal TD Volume Fraction \t Basal RD Volume Fraction \n');
    
elseif ~isempty(test_beta)
    
    phase = 'beta';
    
    if strcmp(material, 'titanium');
      % define beta crystal symmetry
      CS = crystalSymmetry('m-3m', [3.3065 3.3065 3.3065], 'mineral', 'Titanium-beta', 'color', 'light blue');
    
    elseif strcmp(material, 'zirconium');
      % define alpha crystal symmetry
      CS = symmetry('m-3m', [3.62, 3.62, 3.62], 'mineral', 'Zirconium-beta', 'color', 'light blue');
      
    else
        disp('Material input for beta phase not recognised.');
        return;
    end
    
    % open a file to save the texture index values
    fileTI = fopen(fullfile(outputDir, strcat('texture_strength_beta_', experiment_number, '.txt')),'w');
    fprintf(fileTI, 'Test Number \t Texture Index \t ODF Max \t phi1 Angle of ODF Max \t PHI Angle of ODF Max \t phi2 Angle of ODF Max \t {0002} PF Max \t {10-10} PF Max \t {11-20} PF Max \t Basal TD Volume Fraction \t Basal RD Volume Fraction \n');

else
    disp('Phase not recognised from input folder directory.');
    return;
end

%% Define a texture component/fibre for the hexagonal phase

basal_TD = symmetrise(orientation.byEuler(0*degree,90*degree,0*degree,CS),'unique') % define component with Euler angles
basal_RD = symmetrise(orientation.byEuler(90*degree,90*degree,0*degree,CS),'unique')

%% Loop through each of the files and plot the data as pole figures and ODFs

for k = 1:length(inputFiles);
    
  baseFileName = inputFiles(k).name;
  fullFileName = fullfile(inputDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  
  % specify kernel
  psi = deLaValleePoussinKernel('halfwidth',odf_resolution*degree);

  % create an EBSD variable containing the data
  odf = ODF.load(fullFileName,CS,SS,'density','kernel',psi,'resolution',odf_resolution*degree,...
    'interface','generic',...
    'ColumnNames', { 'alpha' 'beta' 'gamma' 'Weight'}, 'Matthies');

  % apply rotate to the data (if required)
  rot = rotation('Euler',euler1*degree,euler2*degree,euler3*degree);
  odf = rotate(odf,rot);
  
  % plot the pole figure
  [maxval] = pole_figure_plot(phase, odf, CS, contour_step, pf_max, outputDir, baseFileName, visible);
  PF_basal_max = maxval(1);
  PF_prismatic1_max = maxval(2);
  PF_prismatic2_max = maxval(3);
  
  % plot the ODF with Orthorhombic Symmetry
  odf.SS=specimenSymmetry('orthorhombic');
  specSym = 'orthorhombic';
  ODF_plot(phase, odf, odf_max, outputDir, baseFileName, specSym, visible);
  
  % calculate a value for the Texture Index with Orthorhombic Symmetry
  TEXTURE_INDEX = textureindex(odf);
  
  % calculate strength of ODF maxima
  [odf_maximum, ori_maximum] = max(odf);

  % calculate Phi1, PHI, Phi2 angle of ODF maxima
  phi1 = ori_maximum.phi1;
  PHI = ori_maximum.Phi;
  phi2 = ori_maximum.phi2;
  
  % seperate a texture component and calculate the volume fraction
  basal_TD_volume_fraction = volume(odf, basal_TD, misorientation*degree);
  basal_RD_volume_fraction = volume(odf, basal_RD, misorientation*degree);
  
  % write the texture indices to file
  %fprintf(fileTI, '%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', baseFileName(12:end-16), TEXTURE_INDEX, odf_maximum, rad2deg(phi1), rad2deg(PHI), rad2deg(phi2), PF_basal_max, PF_prismatic1_max, PF_prismatic2_max, basal_TD_volume_fraction, basal_RD_volume_fraction);
  fprintf(fileTI, '%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', baseFileName(12:end-15), TEXTURE_INDEX, odf_maximum, rad2deg(phi1), rad2deg(PHI), rad2deg(phi2), PF_basal_max, PF_prismatic1_max, PF_prismatic2_max, basal_TD_volume_fraction, basal_RD_volume_fraction);
end

%% Close any open files

fclose(fileTI);