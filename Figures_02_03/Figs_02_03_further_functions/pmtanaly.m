function pmttestdata = pmtanaly(datadir, colchannel)

% runs analysis for a single PMT test session
% developed from pmtanalysis_221213

% datadir       path to data, string
% colchannel    color channel, string { 'g' | 'r' }

datadirparts = strsplit(datadir, filesep);

gm.name = [datadirparts{end-1} '_' datadirparts{end}];

cd([datadir])

if any(strcmpi(colchannel, {'g' 'green'}))
    lst = dir('*.0.tif');
    tterm = '.0.tif';
elseif any(strcmpi(colchannel, {'r' 'red'}))
    lst = dir('*.1.tif');
    tterm = '.1.tif';
else
    warndlg('Can`t find TIFF`s for expected color channel')
    return
end

pvolt = [];
lambda = [];
for n = 1:length(lst)
    partz = strsplit(lst(n).name,'.');
    pvolt(n) = str2num(partz{1});
    lambda(n) = str2num(partz{2});
end

gm.pvolt    = unique(pvolt);

ulambda = unique(lambda);
if ~all(ismember([0 888], ulambda))
    warndlg('Missing either dark of H3 data!')
    return
else
    gm.lambda = ulambda;
end

summary_mean    = NaN(length(gm.pvolt), length(gm.lambda));
summary_var     = NaN(length(gm.pvolt), length(gm.lambda));

% determine offset
a = uint16(imread([datadir filesep num2str(0) '.' num2str(0) tterm], 'tiff', 3));
b = uint16(imread([datadir filesep num2str(0) '.' num2str(0) tterm], 'tiff', 4));
pxoffset = mean( double( [a(:); b(:)] ) )

% Get data for gain calculation
for p = 1:length(gm.lambda)
    for g = 1:length(gm.pvolt)
        try
            a = uint16(imread([datadir filesep num2str(gm.pvolt(g)) '.' num2str(gm.lambda(p)) tterm], 'tiff', 3));
            b = uint16(imread([datadir filesep num2str(gm.pvolt(g)) '.' num2str(gm.lambda(p)) tterm], 'tiff', 4));

            x = [double(a(:));double(b(:))] - pxoffset;
            m = mean( x );
            v = var( x );

            summary_mean(g,p)   = m;
            summary_var(g,p)    = v;
        end
    end
end

summary_mean;
summary_var;


% H3 histograms analysis

hedges  = [-100:1:1200];
Hdata   = [];
Hauc    = [];
for g = 1:length(gm.pvolt)
    try
        a = uint16(imread([datadir filesep num2str(gm.pvolt(g)) '.' num2str(888) tterm], 'tiff', 3));
        b = uint16(imread([datadir filesep num2str(gm.pvolt(g)) '.' num2str(888) tterm], 'tiff', 4));
        xxT = [double(a(:));double(b(:))] - pxoffset;
        hcT = histcounts(xxT, hedges);

        a = uint16(imread([datadir filesep num2str(gm.pvolt(g)) '.' num2str(0) tterm], 'tiff', 3));
        b = uint16(imread([datadir filesep num2str(gm.pvolt(g)) '.' num2str(0) tterm], 'tiff', 4));
        xx0 = [double(a(:));double(b(:))] - pxoffset;
        hc0 = histcounts(xx0, hedges);

        Hdata(:,:,g) = [hc0(:) hcT(:)];

        n = numel(xxT);
        [~,~,~,AUC] = perfcurve([zeros(n,1);ones(n,1)], [xx0(:);xxT(:)], 1);
        Hauc(g) = AUC;
    end
end

gm.summary_mean     = summary_mean;
gm.summary_var      = summary_var;
gm.hedges           = hedges;
gm.Hdata            = Hdata;
gm.Hauc             = Hauc;

pmttestdata = gm;

