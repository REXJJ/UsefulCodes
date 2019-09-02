clear all
clc
close all

%% Load Dataset
load exampledata
Candidates=data;

%% Execute the Autonomous Anomaly Detection software
Input.Data=Candidates; % input
[Output]=AutonomusAnomalyDetection(Input);

%%
Output.IDX % The indices of the anomalies
Output.Anomaly % The anomalies
