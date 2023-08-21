% PMT combined analysis

datasetz = {
    % 'AFK3898', 'R10699SEL', 150925, 'g', '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/150925 PMT testing/greenPMT';
    'AFK3898', 'R10699SEL', 160506, 'g',  630, 9400, 1.00, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/160506 PMT testing/greenPMT';
    'AFK3898', 'R10699SEL', 161221, 'g',  nan, nan, nan, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/161221 PMT testing/greenPMT';
    'AFK3898', 'R10699SEL', 230726, 'g',  nan, nan, nan, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/230726_servicing/6_PMT_AFK3898_green';

    'AFK8564', 'R10699SEL', 161222, 'g', 645, 6380, 0.80, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/161222 PMT testing/greenPMT';
    'AFK8564', 'R10699SEL', 170224, 'g', nan, nan, nan, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/170224_align_test_PMT/4 PMT test AFK8564 green';

    'AFN9975', 'R10699SEL', 170224, 'g', 657, 11000, 0.70, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/170224_align_test_PMT/6 PMT test AFN9975 green';
    'AFN9975', 'R10699SEL', 180102, 'g', nan, nan, nan, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/180102_align_test_PMT/4 PMT test AFN9975';
    'AFN9975', 'R10699SEL', 210529, 'g', nan, nan, nan, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/210529_servicing/4 PMT test AFN9975';

    'AHB4783', 'R10699SEL', 210529, 'g', 650, 8500, 0.67, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/210529_servicing/5 PMT test AHB4783';
    'AHB4783', 'R10699SEL', 221213, 'g', nan, nan, nan, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/221213_servicing/4_PMT_test_AHB4783_green';
    'AHB4783', 'R10699SEL', 230213, 'g', nan, nan, nan, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/230213_servicing/1_PMT_test_AHB4783_green';

    'AFT0343', 'R10699SEL', 230213, 'g', nan, nan, nan, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/230213_servicing/2_PMT_test_AFT0343_green';
    'AFT0343', 'R10699SEL', 230726, 'g', nan, nan, nan, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/230726_servicing/1_PMT_test_AFT0343_green';

    'AFV4331', 'R10699SEL', 230726, 'g', 755, 17200, 1.70, '/Users/ibianco/Library/Mobile Documents/com~apple~CloudDocs/DATA/EXPT/2PLSM design/PMT analysis/230726_servicing/4_PMT_AFV4331_green';

    };

% 1: S/N; 2: Model; 3: Test date; 4: Colour channel; 5: Cathode lum sens (uA/lm); 6: Anode lum sens (A/lm); 7: Dark current (nA); 8: path


compareixx = [1 2 3 8 13 14];
refixx = 5;
timesince = 0; % years

PMThistory = struct();
PMThistory.info = {};
PMThistory.pvolt = [0; 2000; 2500; 2750; 3000; 3250; 3500]; % standard test gains

for d = 1:size(datasetz, 1)

    datadir         = datasetz{d,8}
    colchannel      = datasetz{d,4};

    pmttestdata = pmtanaly(datadir, colchannel);

%     pmtplot(pmttestdata)

    PMThistory.info{1, d} = datasetz{d, 1};
    PMThistory.info{2, d} = datasetz{d, 2};
    PMThistory.info{3, d} = datasetz{d, 3};
    PMThistory.info{4, d} = datasetz{d, 4};

    [lia, loc] = ismember(PMThistory.pvolt, pmttestdata.pvolt);

    PMThistory.AUCg(find(lia),d) = pmttestdata.Hauc(loc(lia));
    darkix = find(ismember(pmttestdata.lambda, 0));
    PMThistory.dark_mean(find(lia),d) = pmttestdata.summary_mean(loc(lia), darkix);
    PMThistory.dark_std(find(lia),d) = sqrt( pmttestdata.summary_var(loc(lia), darkix) );
    H3ix = find(ismember(pmttestdata.lambda, 888));
    PMThistory.H3_mean(find(lia),d) = pmttestdata.summary_mean(loc(lia), H3ix);
    PMThistory.H3_std(find(lia),d) = sqrt( pmttestdata.summary_var(loc(lia), H3ix) );

end


%% Compare PMThistory

tau = 17.75; % (12.3/ln(2), t in years)
decayfactor = exp(-timesince/tau);

cmap = linspace(1, 0, length(compareixx))';
cmap(:, 2:3) = 0;
pvoltrng = [2:7];

figure('Name', '', 'Position', [70 400 1560 420])
splotz = 7;

% H3mean
subplot(1,splotz,1)
%plot(PMThistory.pvolt, PMThistory.H3_mean, 'Color', [.6 .6 .6])
hold on
for i = 1:length(compareixx)
    plot(PMThistory.pvolt, PMThistory.H3_mean(:, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
end
plot(PMThistory.pvolt, PMThistory.H3_mean(:, refixx).*decayfactor, 'k--')
xlabel('HVC [mV]'), ylabel('mean')
xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
title('H3 mean')

% H3std
subplot(1,splotz,2)
%plot(PMThistory.pvolt, PMThistory.H3_std, 'Color', [.6 .6 .6])
hold on
for i = 1:length(compareixx)
    plot(PMThistory.pvolt(pvoltrng), PMThistory.H3_std(pvoltrng, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
end
xlabel('HVC [mV]'), ylabel('std')
xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
title('H3 std')

% darkmean
subplot(1,splotz,3)
%plot(PMThistory.pvolt, PMThistory.H3_mean, 'Color', [.6 .6 .6])
hold on
for i = 1:length(compareixx)
    plot(PMThistory.pvolt, PMThistory.dark_mean(:, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
end
xlabel('HVC [mV]'), ylabel('mean')
xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
title('dark mean')

% darkstd
subplot(1,splotz,4)
%plot(PMThistory.pvolt, PMThistory.H3_std, 'Color', [.6 .6 .6])
hold on
for i = 1:length(compareixx)
    plot(PMThistory.pvolt(pvoltrng), PMThistory.dark_std(pvoltrng, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
end
xlabel('HVC [mV]'), ylabel('std')
xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
title('dark std')

subplot(1,splotz,[5])
ccSNR = (PMThistory.H3_mean - PMThistory.dark_mean)./PMThistory.dark_std;
%plot(PMThistory.pvolt, ccSNR, 'Color', [.6 .6 .6])
hold on
for i = 1:length(compareixx)
    plot(PMThistory.pvolt, ccSNR(:, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
end
xlabel('HVC [mV]'), ylabel('SNR')
xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
title('SNR')

subplot(1, splotz, [6])
auc = PMThistory.AUCg;
%plot(PMThistory.pvolt, auc, 'Color', [.6 .6 .6])
hold on
clear h
for i = 1:length(compareixx)
    hi = plot(PMThistory.pvolt, auc(:, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2);
    h(i) = hi(1);
end
ylim([0.45 1])
xlabel('HVC [mV]'), ylabel('AUC')
xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
title('ROC-AUC')

legtext = {};
for i = 1:length(compareixx)
    legtext{i, 1} = [PMThistory.info{1,compareixx(i)} ':' num2str(PMThistory.info{3,compareixx(i)})];
end
legend(h, legtext);

subplot(1, splotz, [7])
hold on
for i = 1:length(compareixx)
    plot(PMThistory.pvolt, 1e6.*gray2current( PMThistory.H3_mean(:, compareixx(i)) ), 'Color', cmap(i, :), 'LineWidth', 2)
end
xlabel('HVC [mV]'), ylabel('Anode Current [uA]')
xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
title('H3 mean')


%% Compare PMT measurements to Hamamatsu datasheet

cmap = linspace(1, 0, length(compareixx))';
cmap(:, 2:3) = 0;

figure('Name', 'Compare day zero performnace w datasheet')

subplot(1,5,1)
plot( [datasetz{compareixx,5}] , PMThistory.H3_mean(end, compareixx), 'ko', 'MarkerFaceColor', 'k')
xlabel('Cathode lum sens (uA/lm)'), ylabel('H3 mean')

subplot(1,5,2)
plot( [datasetz{compareixx,6}] , PMThistory.H3_mean(end, compareixx), 'ko', 'MarkerFaceColor', 'k')
xlabel('Anode lum sens (A/lm)'), ylabel('H3 mean')

subplot(1,5,3)
SNR = (PMThistory.H3_mean - PMThistory.dark_mean)./PMThistory.dark_std;
plot( [datasetz{compareixx,6}] , SNR(end, compareixx), 'ko', 'MarkerFaceColor', 'k')
xlabel('Anode lum sens (A/lm)'), ylabel('max SNR')

subplot(1,5,4)
plot( [datasetz{compareixx,6}]./[datasetz{compareixx,7}] , SNR(end, compareixx), 'ko', 'MarkerFaceColor', 'k')
xlabel('Anode lum/Dark current'), ylabel('max SNR')

subplot(1,5,5)
plot( [datasetz{compareixx,6}] , PMThistory.AUCg(end, compareixx), 'ko', 'MarkerFaceColor', 'k')
xlabel('Anode lum sens (A/lm)'), ylabel('max ROC-AUC')

%% Compare PMThistory - Packer protocol paper

fgg = struct();
fgg(1).ix = [4 6 9];
fgg(2).ix = [9 10];
fgg(1).timeelapsed = nan;
fgg(2).timeelapsed = 1.5;

tau = 17.75; % (12.3/ln(2), t in years)

for f = [1 2]
    compareixx = fgg(f).ix;
    timesince = fgg(f).timeelapsed;

    decayfactor = exp(-fgg(f).timeelapsed/tau);

    cmap = linspace(1, 0, length(compareixx))';
    cmap(:, 2:3) = 0;
    pvoltrng = [2:7];

    figure('Name', '', 'Position', [70 400 1560 350])
    splotz = 4;

    % H3mean
    subplot(1,splotz,1)
    %plot(PMThistory.pvolt, PMThistory.H3_mean, 'Color', [.6 .6 .6])
    hold on
    for i = 1:length(compareixx)
        plot(PMThistory.pvolt, PMThistory.H3_mean(:, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
    end
    plot(PMThistory.pvolt, PMThistory.H3_mean(:, refixx).*decayfactor, 'k--')
    xlabel('Gain control signal [mV]'), ylabel('Mean px value')
    xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
    title('Mean pixel value (light response)')

%     % H3std
%     subplot(1,splotz,2)
%     %plot(PMThistory.pvolt, PMThistory.H3_std, 'Color', [.6 .6 .6])
%     hold on
%     for i = 1:length(compareixx)
%         plot(PMThistory.pvolt(pvoltrng), PMThistory.H3_std(pvoltrng, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
%     end
%     xlabel('HVC [mV]'), ylabel('std')
%     xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
%     title('H3 std')

%     % darkmean
%     subplot(1,splotz,3)
%     %plot(PMThistory.pvolt, PMThistory.H3_mean, 'Color', [.6 .6 .6])
%     hold on
%     for i = 1:length(compareixx)
%         plot(PMThistory.pvolt, PMThistory.dark_mean(:, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
%     end
%     xlabel('HVC [mV]'), ylabel('mean')
%     xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
%     title('dark mean')

%     % darkstd
%     subplot(1,splotz,4)
%     %plot(PMThistory.pvolt, PMThistory.H3_std, 'Color', [.6 .6 .6])
%     hold on
%     for i = 1:length(compareixx)
%         plot(PMThistory.pvolt(pvoltrng), PMThistory.dark_std(pvoltrng, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
%     end
%     xlabel('HVC [mV]'), ylabel('std')
%     xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
%     title('dark std')

    subplot(1,splotz,2)
    ccSNR = (PMThistory.H3_mean - PMThistory.dark_mean)./PMThistory.dark_std;
    %plot(PMThistory.pvolt, ccSNR, 'Color', [.6 .6 .6])
    hold on
    for i = 1:length(compareixx)
        plot(PMThistory.pvolt, ccSNR(:, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2)
    end
    xlabel('Gain control signal [mV]'), ylabel('SNR')
    xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
    title('SNR')

    subplot(1, splotz, 3)
    auc = PMThistory.AUCg;
    %plot(PMThistory.pvolt, auc, 'Color', [.6 .6 .6])
    hold on
    for i = 1:length(compareixx)
        hi = plot(PMThistory.pvolt, auc(:, compareixx(i)), 'Color', cmap(i, :), 'LineWidth', 2);
        h(i) = hi(1);
    end
    ylim([0.45 1])
    xlabel('Gain control signal [mV]'), ylabel('ROC-AUC')
    xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
    title('ROC-AUC')

    subplot(1, splotz,4)
    hold on
    clear h
    for i = 1:length(compareixx)
        hi = plot(PMThistory.pvolt, 1e6.*gray2current( PMThistory.H3_mean(:, compareixx(i)) ), 'Color', cmap(i, :), 'LineWidth', 2);
        h(i) = hi(1);
    end
    xlabel('Gain control signal [mV]'), ylabel('Anode Current [uA]')
    xlim([PMThistory.pvolt(pvoltrng(1)) PMThistory.pvolt(pvoltrng(end))])
    title('Mean anode current')

    legtext = {};
    for i = 1:length(compareixx)
        legtext{i, 1} = [PMThistory.info{1,compareixx(i)} ':' num2str(PMThistory.info{3,compareixx(i)})];
    end
    legend(h, legtext);

end








