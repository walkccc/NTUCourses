% DIP Homework Assignment #3 
% May 2, 2018
% Name: Jay Chen
% ID #: B03902129 
% email: b03902129@ntu.edu.tw

%#########################################################################
% Add path first
%#########################################################################

disp('Add path "./prob1", "./prob2", "./bonus" and "./readwriter"');
addpath('./prob1');
addpath('./prob2');
addpath('./bonus');
addpath('./readwriter');

disp('Make a parent folder "./outputs"');
mkdir . outputs

%######################################################################### 
% Problem 1: MORPHOLOGICAL PROCESSING                                           
% Implementation 1: Boundary extraction, I1 -> B     
% Implementation 2: Count the number of objects based on morphological
%                   processing
% Implementation 3: Skeletonizing, I1 -> S
% M-files: prob1.m, boundaryExtract.m, countObjects.m, dilateBinary.m, 
%                   label.m and skeletonize.m
% Output: B.raw and S.raw
% Usage: run prob1 to call other .m files
% Parameters:
%       * Boundary Extraction: window size = 3 x 3
%       * Dilation: window size = 9 x 9
%       * Skeletonizing: 8-neighbors
%#########################################################################

fprintf('----------------------------------------\n');
fprintf('Running "prob1"\n----------------------------------------\n');
prob1();

%######################################################################### 
% Problem 2: TEXTURE ANALYSIS                                           
% Implementation 1: Perform Law's method, I2 -> K         
% Implementation 2: Generate another texture image, K -> exchanged
% M-files: prob2.m, law.m, computeEnergy.m, kmeans.m, findTextures.m, 
%          crossMedianFilter.m and exchange.m
% Usage: run prob2 to call other .m files
% Output: K.raw
% Parameters:
%       * Energy Computation: window size = 13
%       * kmeans: initial centroids: (128, 128), (256, 256) and (384, 384)
%       * Texture finding: 
%           * T1(i, j) = 13520
%           * T1(i, j) > 20000 && T2(i, j) > 3500
%       * Cross Median Filter: window size = 61
%#########################################################################

fprintf('----------------------------------------\n');
fprintf('Running "prob2"\n----------------------------------------\n');
prob2();

%######################################################################### 
% Bonus                                           
% Implementation 1: Produce an image by appropriate morphological
%                   processing
% M-files: bonus.m and dilate.m
% Usage: run bonus to call other .m files
% Output: None
% Parameters:
%       * Cross Median Filter: window size = 25
%       * Dilation: window size = 11
%#########################################################################

fprintf('----------------------------------------\n');
fprintf('Running "bonus"\n----------------------------------------\n');
bonus();
