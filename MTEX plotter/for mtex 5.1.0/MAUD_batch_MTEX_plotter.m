%% User Inputs...

%% Specify the Experiment Number

experiment_number = '065';

%% Specify the Material

material = 'titanium';
%material = 'zirconium'

%% Specify ODF Resolution

odf_resolution = 10;

%% Specify Rotation (if required)

euler1 = 90;
euler2 = 90;
euler3 = 0;

%% Specify Specimen Symmetries

SS = specimenSymmetry('1');

%% Specify the PF plotting convention and maxima and the ODF maxima

% plotting convention
setMTEXpref('xAxisDirection','north');
setMTEXpref('zAxisDirection','intoPlane');

pf_max = 4; % set the pole figure maxima 

odf_max = 10; % set the ODF maxima

%% Specify whether figures are visible (will pop-up)

visible = 'on';
%visible = 'off';

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
    fileTI = fopen(fullfile(outputDir, strcat('texture_index_alpha_', experiment_number, '.txt')),'w');
    fprintf(fileTI, 'Filename\tTexture Index Triclinic\tTexture Index Orthorhombic\n');
    
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
    fileTI = fopen(fullfile(outputDir, strcat('texture_index_beta_', experiment_number, '.txt')),'w');
    fprintf(fileTI, 'Filename\tTexture Index Triclinic\tTexture Index Orthorhombic\n');

else
    disp('Phase not recognised from input folder directory.');
    return;
end

%% Loop through each of the files and plot the data as pole figures and ODFs

for k = 1:length(inputFiles);
    
  baseFileName = inputFiles(k).name;
  fullFileName = fullfile(inputDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  
  % specify kernel
  psi = deLaValeePoussinKernel('halfwidth',odf_resolution*degree);

  % create an EBSD variable containing the data
  odf = loadODF(fullFileName,CS,SS,'density','kernel',psi,'resolution',odf_resolution*degree,...
    'interface','generic',...
    'ColumnNames', { 'alpha' 'beta' 'gamma' 'Weight'}, 'Matthies');

  % apply rotate to the data (if required)
  rot = rotation('Euler',euler1*degree,euler2*degree,euler3*degree);
  odf = rotate(odf,rot);
  
  % calculate a value for the Texture Index
  TEXTURE_INDEX = textureindex(odf);
  
  % plot the pole figure
  pole_figure_plot(phase, odf, CS, pf_max, outputDir, baseFileName, visible);
  
  % plot the ODF
  specSym = 'triclinic';
  ODF_plot(phase, odf, odf_max, outputDir, baseFileName, specSym, visible);
  
  % plot the ODF with Orthorhombic Symmetry
  odf.SS=specimenSymmetry('orthorhombic');
  specSym = 'orthorhombic';
  ODF_plot(phase, odf, odf_max, outputDir, baseFileName, specSym, visible);
  
  % calculate a value for the Texture Index with Orthorhombic Symmetry
  TEXTURE_INDEX_ORTHO = textureindex(odf);
  
  % write the texture indices to file
  fprintf(fileTI, '%s\t%f\t%f\n', baseFileName(5:end-4), TEXTURE_INDEX, TEXTURE_INDEX_ORTHO);
  
end

%% Close any open files

fclose(fileTI);