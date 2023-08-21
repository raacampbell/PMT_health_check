# Figures for PMT check



## Figures 2 and 3
Just `cd` to `Figures_02_03` and run `PMT_Figure_02` and `PMT_Figure_03`. 


## Figure 5
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=raacampbell/PMT_health_check&file=example.mlx)

To load data and make summary stats
```matlab
rawdata = readImageData;
summary = processImageData(rawdata);
```

Data are then plotted:
```matlab
PMT_Figure_05(summary)
```



## Figure Standards
* Font: Arial (Symbol for Greek letters)
* Font size: Figures are best prepared at a width of 90 mm (single column) and 180 mm (double column) with a maximum height of 170mm.. At this size, the font size should be 5-7pt. 
* Font sizes: no more than three sizes in a figure
* Ticks: inward
* NPG say: "_Lettering in figures (labelling of axes and so on) should be in lower-case type, with the first letter capitalized and no full stop._"
* Panel labels: lower case, largest font size, bold, up and left of panel, usually (but not always) not touching any panel content i.e. leave white space between panels (not hard rule) 
* Save as vector (eps will do). 
* Add boxes around figures
