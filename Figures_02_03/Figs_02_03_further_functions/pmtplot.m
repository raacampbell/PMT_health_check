function pmtplot(pmttestdata)

gm = pmttestdata;

%% SYSTEM GAIN

figure('Name', [gm.name ' : SYSTEM GAIN'])

pltrng = find(~ismember(gm.lambda, 888));
subplot(1,2,1)
colorpick=distinguishable_colors(length(gm.pvolt));
hold on
for r = 1:length(gm.pvolt)
    plot(gm.summary_mean(r,pltrng), gm.summary_var(r,pltrng), '-o', 'Color',colorpick(r,:));
end
xlabel('mean'), ylabel('variance')
legend(num2str(gm.pvolt'))
title('Var v Mean')

subplot(1,2,2)
pltrng = find(~ismember(gm.lambda, [0 888])); % don't do the first (zero laser) or last column (888 3H)
colorpick=distinguishable_colors(length(gm.pvolt));
hold on
for r = 2:length(gm.pvolt) % ignore first row at zeros laser
    plot(gm.summary_mean(r,pltrng), gm.summary_var(r,pltrng)./gm.summary_mean(r,pltrng),'o-','Color',colorpick(r,:));
end
xlabel('mean'), ylabel('var/mean')
legend(num2str(gm.pvolt(2:end)'))
title('Var/Mean vs Mean')


%% H3 vs dark

H3ix = find(ismember(gm.lambda, 888));
darkix = find(ismember(gm.lambda, 0));

figure('Name',[gm.name ' : 3H Tritium Standard'])
subplot(1,4,1)
plot(gm.pvolt, gm.summary_mean(:,darkix),'k')
hold on
plot(gm.pvolt, gm.summary_mean(:,H3ix),'r')
title('Mean px value : 3H (red) and dark (black)')

subplot(1,4,2)
plot(gm.pvolt, sqrt(gm.summary_var(:,H3ix)),'r')
hold on
plot(gm.pvolt, sqrt(gm.summary_var(:,darkix)),'k')
title('Std px value : 3H (red) and dark (black)')

% SNR: change in pixel value in multiples of dark std
H3SNR = (gm.summary_mean(:,H3ix) - gm.summary_mean(:,darkix))./sqrt(gm.summary_var(:,darkix));
subplot(1,4,3)
plot(gm.pvolt, H3SNR,'k')
xlabel('PMT gain [mV]')
ylabel('SNR')
title('SNR [ mean(H3)-mean(dark) / std(dark) ]')

subplot(1,4,4)
plot(gm.pvolt, 1e6.*gray2current(gm.summary_mean(:,H3ix)),'k')
xlabel('PMT gain [mV]')
ylabel('Anode Current [uA]')



%% HISTOGRAMS and AUC

spr = ceil(length(gm.pvolt)/2);
figure('Name', 'Gray value histograms Tritium vs dark, at varying PMT gain')
for g = 1:length(gm.pvolt)
    subplot(spr,2,g)
    plot(gm.hedges(1:end-1)+.5, gm.Hdata(:,1,g)./sum(gm.Hdata(:,1,g)), 'k', 'LineWidth', 2)
    hold on
    plot(gm.hedges(1:end-1)+.5, gm.Hdata(:,2,g)./sum(gm.Hdata(:,2,g)), 'r', 'LineWidth', 2)
    xlabel('px value'), ylabel('fraction')
    xlim([-100 600])
    title(['Gain = ' num2str(gm.pvolt(g)) '  AUC = ' num2str(gm.Hauc(g), 2)])
end

figure('Name', 'PMT gain versus AUC (Tritium vs dark)')
plot(gm.pvolt, gm.Hauc, 'ko')



