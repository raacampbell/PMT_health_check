function PMT_Figure_03

    % Change in PMT performance over time.
    % Data collected for a Hamamatsu R10699 PMT when it was first installed and after
    % 1.5 years of routine use. Dashed line shows pixel values expected based upon
    % tritium decay alone.

    % Note: labels added by harmonize_figs_02_03

    load('PMThistory_for_figs_02_03.mat')


    PMTs_to_plot = [9 10];
    timeElapsedInYears = 1.5; % Since PMT installation
    tau = 17.75; % (12.3/ln(2), t in years)
    refixx = 5; % Unknown


    % Report to CLI what is being plotted
    fprintf('\n%s is plotting data for the following PMTs:\n', mfilename)
    for ii = 1:length(PMTs_to_plot)
        disp([PMThistory.info{1,PMTs_to_plot(ii)}, ':', ...
         num2str(PMThistory.info{3,PMTs_to_plot(ii)})]);
    end


    tFig = figure(1245435);
    clf



    decayfactor = exp(-timeElapsedInYears/tau);

    % The color map for the line
    cmap = [0,0,0; 0.65,0.65,0.65];

    pvoltrng = 2:7; % x voltage range


    % Mean response as a function of gain
    s(1) = subplot(1,4,1);
    set(s(end),'Tag','mean/gain')
    hold on
    for ii = 1:length(PMTs_to_plot)
        plot(PMThistory.pvolt, PMThistory.H3_mean(:, PMTs_to_plot(ii)), 'Color', cmap(ii, :), 'LineWidth', 2)
    end
    plot(PMThistory.pvolt, PMThistory.H3_mean(:, refixx).*decayfactor, 'k--')



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

    % Add a legend
    legendText = {'Baseline', '+18 months'};
    legend(h, legendText);


    % HARMONIZE (ADDING LABELS, ETC) AND NEATEN
    harmonize_figs_02_03


    % write to disk
    print('-depsc','-r300',[mfilename,'.eps'])
    print('-dpng','-r300',[mfilename,'.png'])
