clc;
clear;
close all;

% a = rand(10000,10000);
% b = rand(10000,10000);
% 
% tic;
% c = a*b;
% toc;


A = gpuArray(rand(10000,10000));
B = gpuArray(rand(10000,10000));

tic;
c = A*B;
toc;