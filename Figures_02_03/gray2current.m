function I = gray2current(pxvalue)
% Convert grayscale value to a current value
%
% function I = gray2current(pxvalue)
%
% Purpose
% Convert grayscale values to a current value.
%
% Inputs
% pxvalue - pixel value
%
% Outputs
% I - current value
%
%


V = pxvalue./2048;

I = V.*100e-6;
