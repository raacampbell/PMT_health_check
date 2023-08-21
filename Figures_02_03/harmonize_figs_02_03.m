function harmonize_figs_02_03(hFig)
    % Called from functions that make figures 2 and 3

    if nargin<1
        hFig = gcf;
    end


    addTitles = false;


    set(hFig, ...
        'Units', 'Inches', ...
        'Position', [0.1, 1, 11, 3.25], ...
        'InvertHardCopy', 'off')

    ax = findobj(gcf,'Type','Axes');


    % Set x axis label for all
    xLabelString = 'Gain control signal [mV]';
    arrayfun(@(t_ax) set(t_ax.XLabel,'String',xLabelString), ax)


    % Set X scale the same for all
    set(ax,'XLim',[2000,3500], ...
            'Box', 'on')



    %% Set specific plot property labels


    % mean
    ax = findobj(gcf,'Tag','mean/gain');
    ax.YLabel.String = 'Mean pixel value';
    addFigCharLabel(ax,'a')
    if addTitles
        ax.Title.String = 'Mean pixel value (light response)';
    end

    % SNR
    ax = findobj(gcf,'Tag','snr/gain');
    ax.YLabel.String = 'SNR';
    addFigCharLabel(ax,'b')
    if addTitles
        ax.Title.String = 'SNR';
    end

    % AUC
    ax = findobj(gcf,'Tag','auc/gain');
    ax.YLabel.String = 'ROC-AUC';

    ax.YLim = [0.45 1];
    addFigCharLabel(ax,'c')
    if addTitles
        ax.Title.String = 'ROC-AUC';
    end

    % current/gain
    ax = findobj(gcf,'Tag','current/gain');
    ax.YLabel.String = 'Mean Anode Current [\muA]';

    addFigCharLabel(ax,'d')
    if addTitles
        ax.Title.String = 'Mean anode current';
    end
