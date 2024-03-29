function [maxval] = pole_figure_plot(phase, odf, CS, contour_step, pf_max, outputDir, baseFileName, visible);
% A function for plotting alpha (hexagonal close-packed) or beta (body-centred-cubic) pole figures using MTEX
  
  if strcmp(visible, 'on');  
    set(0,'DefaultFigureVisible','on'); 
    set(groot,'DefaultFigureVisible','on');
  elseif strcmp(visible, 'off');
    set(0,'DefaultFigureVisible','off');
    set(groot,'DefaultFigureVisible','off');
  else
    disp ('Visibility of pole figures not set as on or off.');
    return;
  end

  if strcmp(phase, 'alpha');
    PF = figure();
    hkil = [Miller(0,0,0,2,odf.CS), Miller(1,0,-1,0,odf.CS), Miller(1,1,-2,0,odf.CS)]; % include hkil figures here
    plotPDF(odf, hkil,'antipodal', 'contourf', 0:contour_step:pf_max, 'minmax') % plot with contouring
    %plotPDF(odf, hkil, 'antipodal', 'minmax'); % plot without contouring
    text(vector3d.X, 'RD', 'VerticalAlignment', 'bottom'); % moving the vector3d axis labels outside of the hemisphere boundary
    text(vector3d.Y, 'TD', 'horizontalAlignment', 'left');
    f = gcm; % moving up the hkil labels to make room for the rolling direction labels
    
    for i = 1:length(f.children)
        f.children(i).Title.Position=[1,1.25,1]; % use [-1,1.25,1] to make layout similar to Channel 5 and turn off minmax if you want to
        ax = getappdata(f.children(i),'sphericalPlot');
        minval(i) = ax.minData;
        maxval(i) = ax.maxData;
    end

    CLim(gcm,[0 pf_max]); % define a colour giving the range (gcm, [min, max])
    mtexColorbar ('location', 'southOutSide', 'title', 'mrd'); % move colorbar to horizontal to avoid overlap
    set(gcf, 'PaperPositionMode', 'auto');
    saveas (PF, fullfile(outputDir, strcat('alpha_pole_figure_', baseFileName(5:end-4), '.png')));
    close(PF);

  elseif strcmp(phase, 'beta');
    PF = figure();
    hkil = [Miller(0,0,1,odf.CS), Miller(1,1,0,odf.CS), Miller(1,1,1,odf.CS)]; % include hkil figures here
    plotPDF(odf, hkil,'antipodal', 'contourf', 0:contour_step:pf_max, 'minmax') % plot with contouring
    %plotPDF(odf, hkil, 'antipodal', 'minmax'); % plot without contouring
    text(vector3d.X, 'RD', 'VerticalAlignment', 'bottom'); % moving the vector3d axis labels outside of the hemisphere boundary
    text(vector3d.Y, 'TD', 'horizontalAlignment', 'left');
    f = gcm; % moving up the hkil labels to make room for the rolling direction labels
    
    for i = 1:length(f.children)
        f.children(i).Title.Position=[1,1.25,1]; % use [-1,1.25,1] to make layout similar to Channel 5 and turn off minmax if you want to
        ax = getappdata(f.children(i),'sphericalPlot');
        minval(i) = ax.minData;
        maxval(i) = ax.maxData;
    end
    
    CLim(gcm,[0 pf_max]); % define a colour giving the range (gcm, [min, max])
    mtexColorbar ('location', 'southOutSide', 'title', 'mrd'); % move colorbar to horizontal to avoid overlap
    set(gcf, 'PaperPositionMode', 'auto');
    saveas (PF, fullfile(outputDir, strcat('beta_pole_figure_', baseFileName(5:end-4), '.png')));
    close(PF);
  
  else 
    disp ('Phase not recognised for plotting pole figures.');
    return;
  end
  
end