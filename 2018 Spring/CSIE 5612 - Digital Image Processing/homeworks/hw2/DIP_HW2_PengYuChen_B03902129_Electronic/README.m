% DIP Homework Assignment #2 
% April 11, 2018
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

%######################################################################### 
% Problem 1: EDGE DETECTION                                           
% Implementation 1: 1st order edge detection     
% Implementation 2: 2nd order edge detection
% Implementation 3: Canny edge detection
% Implementation 4: Generate the edge map by avoiding obtaining edges of
%                   the noise
% M-files: prob1.m, edgeDetectFirst.m, edgeDetectSecond.m and
%                   edgeDetectCanny.m
% Output: None
% Usage: run prob1 to call other .m files
%#########################################################################

fprintf('----------------------------------------\n');
fprintf('Running "prob1"\n----------------------------------------\n');
prob1();

%######################################################################### 
% Problem 2: GEOMETRICAL MODIFICATION                                           
% Implementation 1: Perform edge crispening, I3 -> C         
% Implementation 2: Design a warping function, C -> D
% M-files: prob2.m
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

%######################################################################### 
% Problem 2: Bonus                                           
% Implementation 1: Design an algorithm to enhance images
% M-files: bonus.m
% Usage: run bonus to call other .m files
% Output: None
%#########################################################################

fprintf('----------------------------------------\n');
fprintf('Running "bonus"\n----------------------------------------\n');
bonus();
