function rawdata = readImageData(dataPath)
% Read raw data from tiffs in directory and return as matrix of dimensions
% ypixels, xpixels, frames, PMT (PMTs 1-4), gain, control/greenTrit/redTritium
%
% Inputs
% dataPath - path to data. optional. 'packer_images' by default
%
% Outputs
% rawdata - matrix containing raw data from images



if nargin < 1
    dataPath='packer_images';
end

LSname{1} = '_control_';
LSname{2} = '_greenTritium_';
LSname{3} = '_redTritium_';

%% read all raw data
 % dims are: ypixels, xpixels, frames, PMT (PMTs 1-4), gain, control/greenTrit/redTritium
rawdata=zeros([512,512,1,4,10,3]);

for g=1:10
    for LS=1:3
        for PMT=1:4
           filepath = fullfile(dataPath, ['PMT' num2str(PMT) LSname{LS} num2str(g,'%03i') '.tif']);
           im_data = imread(filepath);

           rawdata(:,:,:,PMT,g,LS) = im_data(:,:,1:2:end);
        end
    end
end

