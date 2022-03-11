% grainEnvMatrix.m
%% This script generates grain envelope matrices from given grain lengths

function [grainEnvMatrix] = grainEnvMatrix(numframes,movingAverageFilt,grainMatrix)

grainEnvMatrix = zeros(size(grainMatrix));

for n = 1:numframes 
    grainEnv = movingAverageFilt(grainMatrix(:,n));
    grainEnvMatrix(:,n) = grainEnv;
end