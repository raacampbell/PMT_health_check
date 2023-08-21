function summary = processImageData(rawdata)
    % Process rawdata matrix - calculate histograms and AUC from mean, variance, and SNR
    %
    % Purpose
    % Analyse raw image data, calculating PMT health stats.
    %
    %
    % Inputs
    % rawdata - [optional] The output of readImageData. By default (no input args) this is
    %           run automatically.
    %
    % Outputs
    % summary - structure which is read into plot_PMT_health
    %
    %
    % Isaac Bianco, Bruno Pichler, Rob Campbell - 2023


    if nargin<1
        fprintf('Reading image data with "readImageData\n')
        rawdata = readImageData;
    end

    %% calculate mean & variance & SNR
    for PMT=1:size(rawdata,4)
        for g=1:size(rawdata,5)
                for LS=1:size(rawdata,6)
                lightframes=rawdata(:,:,:,PMT,g,LS);
                darkframes=rawdata(:,:,:,PMT,g,1); % for calculating offset
                offset(g,PMT)=mean(double(darkframes(:)));
                data=double(lightframes(:))-offset(1,PMT);
                summary.mean(PMT,g,LS)=mean(data);
                summary.var(PMT,g,LS)=var(data);
                summary.std(PMT,g,LS)=sqrt(summary.var(PMT,g,LS));
                summary.SNR(PMT,g,LS)=(summary.mean(PMT,g,LS)-summary.mean(PMT,g,1))/summary.std(PMT,g,1);
            end
        end

    end


    %% calculate histograms & AUC
    % rawdata dims are: ypixels, xpixels, frames, green/red, gain, dark/low/high

    hedges  = -300:1:300; % [min(rawdata(:)):1:max(rawdata(:))];
    Hdata   = [];
    summary.hAUC    = [];

    fprintf('Calculating AUCs')
    prog = 0;
    for g=1:size(rawdata,5)
        for PMT=1:size(rawdata,4)
            xx0=rawdata(:,:,:,PMT,g,1)-offset(g,PMT);
            hc0=histcounts(xx0(:),hedges);


                for LS=1:size(rawdata,6)
                    xxT=rawdata(:,:,:,PMT,g,LS)-offset(g,PMT);
                     hcT=histcounts(xxT(:),hedges);
                    n = numel(xxT);
                    [~,~,~,AUC] = perfcurve([zeros(n,1);ones(n,1)], [xx0(:);xxT(:)], 1);
                    summary.hAUC(PMT,g,LS) = AUC;
                    prog = prog+1;
                    if mod(prog,10)==0
                        fprintf('.')
                    end
                end
        end
    end
    fprintf('\n')
