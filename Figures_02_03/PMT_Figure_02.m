function PMT_Figure_02


    % Performance comparison for three multialkali PMT units of the same model.
    % Data is shown for three Hamamatsu R10699 PMTs on first day of installation.
    % PMTs were tested within the full collection optics system (green channel) of
    % the same microscope. Gain setting is represented by the low voltage control signal.

    % Note: labels added by harmonize_figs_02_03


    load('PMThistory_for_figs_02_03.mat')

    PMTs_to_plot = [4 6 9];

    % Color map
    cmap = [0,0,0; 0.66,0.66,0.66; 1,0,0];



    tFig = figure(1245);
    clf


    % Mean response as a function of gain
    s(1) = subplot(1,4,1);
    set(s(end),'Tag','mean/gain')
    hold on
    for ii = 1:length(PMTs_to_plot)
        plot(PMThistory.pvolt, PMThistory.H3_mean(:, PMTs_to_plot(ii)), 'Color', cmap(ii, :), 'LineWidth', 2)
    end



    % SNR as a function of gain
    s(2) = subplot(1,4,2);
    set(s(end),'Tag','snr/gain')
    ccSNR = (PMThistory.H3_mean - PMThistory.dark_mean)./PMThistory.dark_std;

    hold on
    for ii = 1:length(PMTs_to_plot)
        plot(PMThistory.pvolt, ccSNR(:, PMTs_to_plot(ii)), 'Color', cmap(ii, :), 'LineWidth', 2)
    end



    % ROC-AUC value as a function of gain
    s(3) = subplot(1,4, 3);
    set(s(end),'Tag','auc/gain')
    auc = PMThistory.AUCg;

    hold on
    for ii = 1:length(PMTs_to_plot)
        hi = plot(PMThistory.pvolt, auc(:, PMTs_to_plot(ii)), 'Color', cmap(ii, :), 'LineWidth', 2);
        h(ii) = hi(1);
    end




    % Calculated mean anode current as a function of gain
    s(4) = subplot(1,4,4);
    set(s(end),'Tag','current/gain')
    hold on

    clear h
    for ii = 1:length(PMTs_to_plot)
        hi = plot(PMThistory.pvolt, 1e6.*gray2current( PMThistory.H3_mean(:, PMTs_to_plot(ii)) ), 'Color', cmap(ii, :), 'LineWidth', 2);
        h(ii) = hi(1);
    end

    % Make a legend on the final plot
    legendText = {};
    for ii = 1:length(PMTs_to_plot)
        legendText{ii, 1} = PMThistory.info{1,PMTs_to_plot(ii)};
    end
    legend(h, legendText);


    % HARMONIZE (ADDING LABELS, ETC) AND NEATEN
    harmonize_figs_02_03


    % write to disk
    print('-depsc','-r300',[mfilename,'.eps'])
    print('-dpng','-r300',[mfilename,'.png'])
