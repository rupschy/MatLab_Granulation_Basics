% grainGenerator.m
function [grainMatrix, numframes] = grainGenerator(signal,Fs,grainSize) 


% [signal,Fs] = audioread('AcGtr.wav');
% signal = signal(1:308700,1);
% Need a way to show input length and what output should be
lenIn = length(signal);

win = hanning(grainSize);
strt=1;
hop = grainSize/2;
nend=grainSize;

grainMatrix = zeros(grainSize,lenIn/grainSize); %creates grain matrix to output all signal pieces
% [grainSize,numFrames] = size(grainMatrix);
numframes = floor((lenIn-grainSize+hop)/hop);

grainMatrix(:,1) = (signal(1:grainSize,1).*win);

for n = 2:numframes
    
    grainMatrix(:,n) = signal(strt+(hop*(n-1)):nend+(hop*(n-1)),1);
    
end

grainMatrix = grainMatrix.*win;



end

