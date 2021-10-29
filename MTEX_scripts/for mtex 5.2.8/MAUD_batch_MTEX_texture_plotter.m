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

pf_max = 5; % set the pole figure maxima 

odf_max = 8; % set the ODF maxima

%% Specify whether figures are visible (will pop-up)

%visible = 'on';
visible = 'off';

%% Define the main starting orientation 

start_euler1 = 90;
start_euler2 = 90;
start_euler3 = 0;

%% Define the maximum possible misorientation for component analysis

misorientation = 10

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
    fprintf(fileTI, 'Filename\tTexture Index Triclinic\tTexture Index Orthorhombic\tODF Maxima\tODF Misorientation\tPhi1\tPHI\tPhi2\n');
    
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
    fprintf(fileTI, 'Filename\tTexture Index Triclinic\tTexture Index Orthorhombic\tODF Maxima\tODF Misorientation\tPhi1\tPHI\tPhi2\n');

else
    disp('Phase not recognised from input folder directory.');
    return;
end

%% Define a texture component/fibre for the hexagonal phase

% basal_LD = symmetrise(orientation.byMiller([1 1 -2 0],[1 0 -1 0],CS),'unique'); % define component with directions
basal_LD = symmetrise(orientation.byEuler(0*degree,0*degree,0*degree,CS),'unique') % define component with Euler angles
basal_IB = symmetrise(orientation.byEuler(0*degree,30*degree,0*degree,CS),'unique')
basal_TD = symmetrise(orientation.byEuler(0*degree,30*degree,0*degree,CS),'unique')

basal_LD_fibre = fibre(Miller(0,0,0,2,CS),xvector); % define fibre with directions
basal_IB_fibre = fibre(Miller(0,0,0,2,CS),zvector);
basal_TD_fibre = fibre(Miller(0,0,0,2,CS),yvector);

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
  
  % calculate strength of ODF maxima
  [odf_maximum, ori_maximum] = max(odf)

  % calculate misorientation of ODF maxima wrt main starting orientation
  mori = (orientation.byEuler(start_euler1*degree,start_euler2*degree,start_euler3*degree,CS))*ori_maximum
  misorientation_ODF_max = angle(mori)/degree

  % calculate Phi1, PHI, Phi2 angle of ODF maxima
  Phi1 = ori_maximum.phi1*180/pi()
  PHI = ori_maximum.Phi*180/pi()
  Phi2 = ori_maximum.phi2*180/pi()
  
  % write the texture indices to file
  fprintf(fileTI, '%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', baseFileName(5:end-4), TEXTURE_INDEX, TEXTURE_INDEX_ORTHO, odf_maximum, misorientation_ODF_max, Phi1, PHI, Phi2);
  
end

%% Close any open files

fclose(fileTI);