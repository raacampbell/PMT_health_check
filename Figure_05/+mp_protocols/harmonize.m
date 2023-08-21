function harmonize(hFig)
    % Harmonize figure using our style guidelines
    %
    % function mp_protocols.harmonize(hFig)
    %
    % Purpose
    % Set all elements in figure such that they as far as possible meet the NPG guidelines
    % and the guidelines we have set. There is no guarantee that all guidelines will be
    % met by running this function. i.e. it has not been extensively tested. However,
    % running it should get most thing correct and we can always augment this function to
    % cover more cases as they come up.
    %
    % Inputs
    % hFig - [optional] The figure window on which to operate. If missing, the function
    %        runs on the current figure (gcf) .
    %
    % Outputs
    % none
    %
    %
    % Example
    % clf
    % AX = subplot(1,2,1);
    % plot(randn(1,100))
    %
    % AX(2) = subplot(1,2,2);
    % plot(randn(1,100)*3)
    %
    % mp_protocols.harmonize(AX)
    %
    % Rob Campbell, SWC 2023

    if nargin<1
        hFig = gcf;
    end

    % All axes in this figure window
    hAx = mp_protocols.getAllAxesInFigure(hFig);

    set(hAx, ...
        'TickDir', 'in', ...
        'Box', 'on');

