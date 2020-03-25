function [  ] = ODF_plot(phase, odf, odf_max, outputDir, baseFileName, specSym);
% A function for plotting slices of the alpha (hexagonal close-packed) or beta (body-centred-cubic) ODF using MTEX

  if strcmp(phase, 'alpha');
    ODF_fig = figure('visible', 'off');
    plot(odf, 'PHI2', [0 15 30]*degree);
    CLim(gcm,[0,odf_max]); % define a colour giving the range (gcm, [min, max])
    mtexColorbar ('location', 'southOutSide', 'title', 'mrd'); % move colorbar to horizontal to avoid any overlap
    set(gcf, 'PaperPositionMode', 'auto');
    if strcmp(specSym, 'orthorhombic')
      saveas (ODF_fig, fullfile(outputDir, strcat('alpha_ODF_orthorhombic_', baseFileName(5:end-4), '.bmp')));
    elseif strcmp(specSym, 'triclinic')
      saveas (ODF_fig, fullfile(outputDir, strcat('alpha_ODF_triclinic_', baseFileName(5:end-4), '.bmp')));
    else 
      disp('specSym not satisfied - choose orthorhombic or triclinic');
    end
  
  elseif strcmp(phase, 'beta');
    ODF_fig = figure('visible', 'off');
    plot(odf, 'PHI2', [0 45]*degree);
    CLim(gcm,[0,odf_max]); % define a colour giving the range (gcm, [min, max])
    mtexColorbar ('location', 'southOutSide', 'title', 'mrd'); % move colorbar to horizontal to avoid any overlap
    set(gcf, 'PaperPositionMode', 'auto');
    if strcmp(specSym, 'orthorhombic')
      saveas (ODF_fig, fullfile(outputDir, strcat('beta_ODF_orthorhombic_', baseFileName(5:end-4), '.bmp')));
    elseif strcmp(specSym, 'triclinic')
      saveas (ODF_fig, fullfile(outputDir, strcat('beta_ODF_triclinic_', baseFileName(5:end-4), '.bmp')));
    else 
      disp('specSym not satisfied - choose orthorhombic or triclinic');
    end
    
  else 
    disp ('Phase not recognised for plotting ODF slices.'); 
    return;
  end
end