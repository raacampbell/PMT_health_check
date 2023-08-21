function varargout = PMT_Figure_05(summary)
    %% PMT analysis
    %
    % function PMT_Figure_05(summary)
    %
    % Purpose
    % Makes plots showing PMT health checks for a range of PMTs.
    %
    % Inputs
    % summary - [optional] output of "processImageData". See readme file.
    %        If not supplied, the data are calculated. If you are running multiple
    %        times to tweak the figure, it will be better to pre-calculate this, as
    %        described in the readme.
    %
    % Outputs
    % hAx - optionally the axis handle objects are returned.
    %
    %
    % Isaac Bianco, Bruno Pichler, Rob Campbell - 2023


    % Set up for plotting

    if nargin<1
        fprintf('Loading and processing raw data.\n')
        summary = processImageData;
    end


    figure(68325)
    clf
    set(gcf,'name', 'PMT AUC', ...
        'Units', 'Inches', ...
        'Position', [0.1, 1, 10, 10], ...
        'InvertHardCopy', 'off')


    nPMTs = size(summary.mean,1);
    gain = 0:100:900; % HARD-CODED!
    hAx = gobjects(0); %axis handles


    genericPlotProps={'LineWidth',2};
    tSp = tiledlayout(4,4,'TileSpacing','Compact','Padding','Compact');

    % Generate the plots with minimal styling in the loop
    for PMT=1:nPMTs

        %Mean gray-scale as a function of gain
        hAx(end+1) = nexttile(PMT);


        plot(gain,squeeze(summary.mean(PMT,:,:)), genericPlotProps{:})
        % Note: colors of lines set after loop

        if PMT==1
            ylabel('grayscale values [a.u.]')
        end

        if PMT==4
            legend({'control';'"green" tritium';'"red" tritium'},'Location','northeast')
        end

        %ylim([min(reshape(summary.mean(PMT,:,:),1,[])) max(reshape(summary.mean(PMT,:,:),1,[]))]);
        title(['PMT ' num2str(PMT)])


        %STD as a function of gain
        hAx(end+1) = nexttile(PMT+nPMTs);
        plot(gain,squeeze(summary.std(PMT,:,:)), genericPlotProps{:})
        if PMT==1
            ylabel('STD')
        end

        %AUC as a function of gain
        hAx(end+1) = nexttile(PMT+nPMTs*2);
        plot(gain, squeeze(summary.hAUC(PMT,:,:)), genericPlotProps{:})
        if PMT==1
            ylabel('AUC')
        end


        %SNR as a function of gain
        hAx(end+1) = nexttile(PMT+nPMTs*3);
        plot(gain,squeeze(summary.SNR(PMT,:,:)), genericPlotProps{:})
        if PMT==1
            ylabel('SNR')
        end

    end


    % Applying styling to plots in a vectorized way

    %% Harmonize plots
    % Local harmonization
    cmap = [0.5,0.5,0.5; 0,0.8,0; 1,0,0];
    set(hAx, ...
        'XLim', [-50,950], ...
        'XTick', 0:150:900, ...
        'YGrid', 'on', ...
        'XGrid', 'on', ...
        'ColorOrder', cmap        );

    % Apply global criteria to all axes
    mp_protocols.harmonize

    % Label the bottom edge
    bottomEdge = hAx(4:nPMTs:end);
    arrayfun(@(tAx) set(tAx.XLabel,'String','Gain [V]'), bottomEdge)


    % Optionally make all Y scales the same
    do_setCommonY = true;
    if do_setCommonY
        disp('Setting Y axis scales to be the same')
        for ii=1:4
            mp_protocols.setCommonY(hAx(ii:nPMTs:end))
        end


        % Remove internal axes for tidiness
        allButBottom = hAx;
        allButBottom(4:nPMTs:end)=[];
        set(allButBottom,'XTickLabel',[])

        set(hAx(5:end), 'YTickLabel', [])
    end




    if nargout > 0
        varargout{1} = hAx;
    end

    % write to disk
    print('-depsc','-r300',[mfilename,'.eps'])
    print('-dpng','-r300',[mfilename,'.png'])
