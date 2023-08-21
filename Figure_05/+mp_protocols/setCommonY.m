function setCommonY(ax,margin)
    % Set the Y axes of all plots in vector "ax" to be the same
    %
    % function mp_protocols.setCommonY(ax)
    %
    % Purpose
    % Set the Y axes of all plots in the vector (ax) to be the same.
    % Ensures that all data on all plots will be visible and adds a
    % small margin so no data points are right on an axis limit.
    %
    % Inputs
    % margin - [optional] 2.5% by default. "margin" can be specified either
    %         as a percentage (2.5) or a proportion (0.025).
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
    % mp_protocols.setCommonY(AX)
    %
    % Rob Campbell, SWC 2023

    if nargin<2
        margin = 0.025;
    end

    % If margin is a percentage we convert to a proportion
    if margin>1
        margin = margin/100;
    end

    x = cell2mat(get(ax,'YLim'));
    y_limits = [min(x(:,1)), max(x(:,2))];

    % Add a buffer
    d = range(y_limits)*margin;
    y_limits(1) = y_limits(1)-d;
    y_limits(2) = y_limits(2)+d;

    set(ax,'YLim', y_limits)
