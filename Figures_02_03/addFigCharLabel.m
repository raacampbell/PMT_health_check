function varargout = addFigCharLabel(ax,labelChar)
    % Add a character label ('a', 'b', etc) to the top right corner of a plot
    %
    % function hLabel = addFigCharLabel(ax,labelChar)
    %
    % Function
    % Add a text label to figure corner. Optionally return the handle of the
    % text object.


    X = ax.XLim;
    Y = ax.YLim;

    labelOffsetPropX = 0.04;
    labelOffsetPropY= 0.05;


    xPos = X(1) + range(X) * labelOffsetPropX;
    yPos = Y(2) - range(Y) * labelOffsetPropY;


    hLabel = text(xPos, yPos, labelChar, ...
        'FontWeight', 'Bold', 'Parent', ax);



    if nargout>0
        varargout{1} = hLabel;
    end
