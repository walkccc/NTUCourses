% DIP Homework Assignment #1 
% March 28, 2018
% Name: Jay Chen
% ID #: B03902129 
% email: b03902129@ntu.edu.tw

%#########################################################################
% Add path first
%#########################################################################

disp('Add path "./warmup", "./prob1", "./prob2" and "./readwriter"');
addpath('./warmup');
addpath('./prob1');
addpath('./prob2');

disp('Make a parent folder "./outputs"');
mkdir . outputs

%######################################################################### 
% WARM-UP: SIMPLE MANIPULATIONS                                           
% Implementation 1: Convert color image(I1) -> gray-level image(gray)     
% Implementation 2: Perform diagonal flipping, I1 -> B                    
% M-files: warmup.m   
% Usage: run warmup
% Output: B.raw
%#########################################################################

fprintf('----------------------------------------\n');
fprintf('Running "warmup"\n----------------------------------------\n');
warmup();

%######################################################################### 
% Problem 1: IMAGE ENHANCEMENT                                            
% Implementation 1: Decrease the brightness, I2 -> D                      
% Implementation 2: Plot the histograms of I2 and D
% Implementation 3: Perform histogram equalization, D -> H
% Implementation 4: Perform local histogram equalization, D -> L
% Implementation 5: Plot the histograms of H and L
% Implementation 6: Perform the log transform, inverse log transform 
%                   and power-law transform
% M-files: prob1.m, plotHist.m, histEq.m, localhist.m and trans.m
% Usage: run prob1 to call other .m files
% Outputs: D.raw, H.raw and L.raw
% Parameters:
%       * Local Histogram Equalization: window size = 3, 5, 7, ..., 255
%       * Log Transformation: c = 5, 15, 25, ..., 85
%       * Inverse Log Transformation: c = 1, 2, 3, ..., 9
%       * Power-Law Transformation: p = 0.2, 0.4, 0.6, ..., 3.0
%#########################################################################

fprintf('----------------------------------------\n');
fprintf('Running "prob1"\n----------------------------------------\n');
prob1();

%######################################################################### 
% Problem 2: NOISE REMOVAL                                            
% Implementation 1: Generate Gaussian noise image, I3 -> G1 / G2         
% Implementation 2: Generate salt-and-pepper noise image, I3 -> S1 / S2
% Implementation 3: Design Low Pass Filter, G1 -> RG
% Implementation 4: Design Median Filter, S1 -> RS
% Implementation 5: Computer PSNR
% Implementation 6: Remove the wrinkles
% M-files: prob2.m, addGaussianNoise.m, addSaltAndPepper.m, lowPassFilter.m
%          squareMedianFilter.m, crossMedianFilter.m, PSNR.m and 
%          removeWrinkle.m
% Usage: run prob2 to call other .m files
% Output: None
% Parameters:
%       * 3 x 3 Low Pass Filter: b = 1, 2, 3, ..., 30
%       * n x n Square Median Filter: window size = 3, 5, 7, ..., 15
%       * n + n - 1 Cross Median Filter: cross size = 3, 5, 7, ..., 15
%       * Wrinkle remover: threshold = 3
%                          crossMedianFilter with cross size = 15
%#########################################################################

fprintf('----------------------------------------\n');
fprintf('Running "prob2"\n----------------------------------------\n');
prob2();
