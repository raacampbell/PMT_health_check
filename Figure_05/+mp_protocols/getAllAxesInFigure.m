function hAx = getAllAxesInFigure(hFig)
    % Return a vector of axis objects that are children of a figure window
    %
    % function hAx = mp_protocols.getAllAxesInFigure(hFig)
    %
    % Purpose
    % Return a vector of axis objects that are children of a figure window.
    %
    % Inputs
    % hFig - [optional] The figure window on which to operate. If missing, the function
    %        runs on the current figure (gcf) .
    %
    % Outputs
    % hAx - vector of axis objects.
    %
    % Rob Campbell, SWC 2023


    if nargin<1
        hFig = gcf;
    end


    hAx = get(hFig,'Children');

    for ii = length(hAx):-1:1
        if ~isa(hAx(ii), 'matlab.graphics.axis.Axes')
            hAx(ii)=[];
        end
    end
