% stochasticPerm.m
function [randmat] = stochasticPerm(in)
% Initialize Arrays, Vectors and Variables
% Initialized for Re-Synthesis in Frequency Domain
X = stft(in);
lenIn = length(in);
[nfft,~] = size(X); %constant length of grains in synchronous granular synthesis

% Initialized for Stochastic Permutation
randmat = zeros(size(X)); %matrix for stochastically arranged Xamp matrix
signalindex = zeros(nfft,1); %vector for random grain placement
framesize = 128;
hopsize = floor(framesize/2);
numframes = floor((lenIn - framesize + hopsize) / hopsize); 
randframes = randperm(numframes)'; %stochastic shape to frequency domain


% Loop for Re-organization for stochastic permutations
for currentframe = 1:numframes
    
    % Use frequency domain magnitude values for stochastic permutations
        signalindex(:,1) = X(:,randframes(currentframe));
    % create frame matrix for stochastically located grains
        randmat(:,currentframe) = signalindex;
        
end