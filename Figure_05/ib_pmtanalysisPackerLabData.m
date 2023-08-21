%%PMT analysis



rawdata = readImageData;
summary = processImageData(rawdata);

%% plot mean, std, SNR, auc

figure(68324)
set(gcf,'name', 'PMT AUC')
for PMT=1:4
    subplot(4,4,PMT); plot(squeeze(summary.mean(PMT,:,:)))

    if PMT==1
        legend({'control';'green-ish H3';'red-ish H3'},'Location','northwest')
        ylabel('grayscale values [a.u.]')
        xlabel('gain [V]')
    end

    xlim([0.5 10.5])
    xticks(1:10)
    xticklabels({'0','100','200','300','400','500','600','700','800','900'})
    %ylim([min(reshape(summary.mean(PMT,:,:),1,[])) max(reshape(summary.mean(PMT,:,:),1,[]))]);
    title(['PMT ' num2str(PMT) ', mean'])
    subplot(4,4,PMT+4); plot(squeeze(summary.std(PMT,:,:)))
    xlim([0.5 10.5])
    xticks(1:10)
    xticklabels({'0','100','200','300','400','500','600','700','800','900'})
   % legend({'dark (lightsource off)';'lightsource setting low';'lightsource setting high'},'Location','northwest')
    %ylim([-10 230]);
    title(['PMT ' num2str(PMT) ', std'])

    subplot(4,4,PMT+8); plot(squeeze(summary.hAUC(PMT,:,:)))
    title(['PMT ' num2str(PMT) ', AUC'])
    xlim([0.5 10.5])
    xticks(1:10)
    xticklabels({'0','100','200','300','400','500','600','700','800','900'})

    subplot(4,4,PMT+12); plot(squeeze(summary.SNR(PMT,:,:)))
    title(['PMT ' num2str(PMT) ', SNR'])
    xlim([0.5 10.5])
    xticks(1:10)
    xticklabels({'0','100','200','300','400','500','600','700','800','900'})

end

