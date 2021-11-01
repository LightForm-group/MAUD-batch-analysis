%% Specify the file names

% path to files
pname = '/Users/mbcx9cd4/Documents/GitHub/MAUD-batch-analysis/results/diamond_2017/';

% where are the texture results located
experiment_number = '065';
phase = 'alpha'
results_file = strcat(experiment_number, '_15deg/',experiment_number,'_texture_plots/',phase,'/','texture_strength_',phase,'_',experiment_number,'.txt')
fname_results = [pname results_file]

% where is the ETMT data located
ETMT_file = strcat('data_ETMT/',experiment_number,'_ETMT.dat')
fname_ETMT = [pname ETMT_file]

% where do we save the plots
analysis_folder = strcat(experiment_number, '_15deg/',experiment_number,'_texture_plots/',phase,'/')
analysis_path = [pname analysis_folder]

%% Load texture results

% import the texture data
texture_results = importdata(fname_results)

% write the data to new arrays
texture_index = texture_results.data(:,1)
odf_max = texture_results.data(:,3)
odf_misori = texture_results.data(:,4)
phi1 = texture_results.data(:,5)
PHI = texture_results.data(:,6)
phi2 = texture_results.data(:,7)

%% Load the ETMT data

% import the ETMT data
ETMT_output = importdata(fname_ETMT)

% write the data to new arrays
ETMT_image_number = ETMT_output.data(:,1)
ETMT_load = ETMT_output.data(:,2)% *25
ETMT_temperature = ETMT_output.data(:,3)% *150
ETMT_position = ETMT_output.data(:,4)% *0.5

%% Get the maxima and minima values

% maxima
max_texture_index = max(texture_index)
max_odf_max = max(odf_max)
max_odf_misori = max(odf_misori)
max_phi1 = max(phi1)
max_PHI = max(PHI)
max_phi2 = max(phi2)

% minima
min_texture_index = min(texture_index)
min_odf_max = min(odf_max)
min_odf_misori = min(odf_misori)
min_phi1 = min(phi1)
min_PHI = min(PHI)
min_phi2 = min(phi2)

%% Or, give global maxima and minima to adjust the values

% maxima
% max_texture_index = 1
% max_odf_max = 1
% max_odf_misori = 1
% max_phi1 = 1
% max_PHI = 1
% max_phi2 = 1

% minima
% min_texture_index = 1
% min_odf_max = 1
% min_odf_misori = 1
% min_phi1 = 1
% min_PHI = 1
% min_phi2 = 1

%% Calculate normalised values

% calculate the normalised values for texture
texture_index_norm = ( texture_index - min_texture_index ) / ( max_texture_index -  min_texture_index )

%% Create an array of image numbers to plot the texture values against

start_number = 3100
step = 5

num_points = length(texture_index)
for index = 1:num_points
    image_number(index) = start_number + (step * index)
end

%% Remove any points with high error values

skipPoints = [3100,3110,3125,3130,3140,3145,3150,3215,3240,3275,3280,3285,3290,3295,3310,3315,3325,3375,3385,3395]; % list points to skip
image_number(ismember(image_number,skipPoints)) = NaN; % remove skip-points, Nan replaces values, [] reduces the array

%% Plot the texture index

% setup the figure
figure_texture_index = figure();
set(gcf, 'Position', [10 10 800 600]) % format is [left bottom width height]
set(gca,'XAxisLocation','bottom','YAxisLocation','left', 'Fontsize', 16, 'lineWidth',2);

% plot the texture index
line(image_number,texture_index, 'Marker','o','Markersize', 10,'lineWidth',3,'lineStyle','none', 'Color', [1 0 0]);
xlabel('Image Number');
ylabel('Texture Index');
xlim([3075 3425])
ylim([1.65 2.1])

saveas (figure_texture_index, strcat(analysis_path,experiment_number,'_texture_index.bmp'));

%% Plot the ODF maximum

% setup the figure
figure_odf_max = figure();
set(gcf, 'Position', [10 10 800 600]) % format is [left bottom width height]
set(gca,'XAxisLocation','bottom','YAxisLocation','left', 'Fontsize', 20, 'lineWidth',2);

% plot the ODF maximum
line(image_number,odf_max,'Marker','o','Markersize', 10,'lineWidth',3,'lineStyle','none','Color', [0.5 0 0.5]);
xlabel('Image Number');
ylabel('ODF Maximum');
xlim([3075 3425])
ylim([7.2 9.1])

saveas (figure_odf_max, strcat(analysis_path,experiment_number,'_odf_max.bmp'));

%% Plot the ODF misorientation

% setup the figure
figure_odf_misori = figure();
set(gcf, 'Position', [10 10 800 600]) % format is [left bottom width height]
set(gca,'XAxisLocation','bottom','YAxisLocation','left', 'Fontsize', 20, 'lineWidth',2);

% plot the ODF misorientation
line(image_number,odf_misori, 'Marker','o','Markersize', 10,'lineWidth',3,'lineStyle','none', 'Color', [0 0 1]);
xlabel('Image Number');
ylabel('ODF Misorientation');
xlim([3075 3425])
ylim([88.5 94])

saveas (figure_odf_misori, strcat(analysis_path,experiment_number,'_odf_misorientation.bmp'));

%% Plot the ETMT data

% setup the figure
figure_odf_misori = figure();
set(gcf, 'Position', [10 10 800 600]) % format is [left bottom width height]
set(gca,'XAxisLocation','bottom','YAxisLocation','left', 'Fontsize', 20, 'lineWidth',2);

% plot the ODF misorientation
line(ETMT_image_number,ETMT_load, 'Marker','o','Markersize', 10,'lineWidth',3,'lineStyle','none', 'Color', [0 0 1]);
hold on
line(ETMT_image_number,ETMT_temperature, 'Marker','o','Markersize', 10,'lineWidth',3,'lineStyle','none', 'Color', [1 0 0]);
hold on
line(ETMT_image_number,ETMT_position, 'Marker','o','Markersize', 10,'lineWidth',3,'lineStyle','none', 'Color', [0.5 0 0.5]);
xlabel('Image Number');
ylabel('Load, Temperature, Position');
xlim([3075 3425])
ylim([-0.5 7])
hold off

saveas (figure_odf_misori, strcat(analysis_path,experiment_number,'_ETMT.bmp'));
