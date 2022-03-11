% granularTestScript.m

%% Input Signal
%two different types of input
[in,Fs] = audioread('water.wav');
in = in(1:240000,1);

in = in/max(abs(in));

gLen = 24000;
outLengthS = 10; % output wanted is 10 seconds and input is 5
outLengthN = outLengthS * Fs;

%function for grain creation and windowing of overlapped grains
[grainMatrix,numframes] = grainGenerator(in,Fs,gLen);

%function for ordering return samples for reconstruction
[permutation,framesOut] = outOrder(outLengthS, Fs, gLen, numframes);

%% Find Moving Average results for given grain

% Each grain envelope will be stored in this matrix for filtering later
grainEnvMatrix = zeros(size(grainMatrix));

% Loop to create matrix for all grain amplitude envelopes
for n = 1:numframes 
    grainEnv = movingAverageFilt(grainMatrix(:,n));
    grainEnvMatrix(:,n) = grainEnv;
end



%% Stochastic Permutation
[nfft,mfft] = size(stft(grainMatrix(:,1))); %constant length of grains in synchronous granular synthesis
randMatrices = zeros(nfft,mfft,numframes);

%% 3-D arrays created for storage of all STFT modulated grains for ISTFT transform

% Create initial 3D arrays
for m = 1:numframes
    randMatrix = stochasticPerm(grainMatrix(:,m));
    randMatrices(:,:,m) = randMatrix;
end

timeMatrices= zeros(size(grainEnvMatrix));

% Create time-domain matrices for amplitude modulation
for p = 1:numframes
   timeMatrices(:,p) = real(istft(randMatrices(:,:,p)));
end

%% Synthesis section via g[m,n] * Xamp[m,n] grain matrix

% Initialize output matrix
outMatrix = zeros(gLen,framesOut);

% Apply amplitude modulation from moving average filtering 
for r = 1:framesOut
    index = permutation(r,1);
    outMatrix(:,r) = (timeMatrices(:,index)).*(grainEnvMatrix(:,index));
%     outMatrix(:,r) = (timeMatrices(:,index));
end

% Initialize output array for final signal 
output = zeros(outLengthN,1);
y = zeros(outLengthN,1);


strt = 1;
nend = gLen;
hop = 0; %will eventually be gLen/2

% Create first iteration outside loop
output(1:gLen,1) = outMatrix(:,1);

% Following loops for final signal
for s = 2:framesOut
    
    output(strt+(hop*(s-1)):nend+(hop*(s-1)),1) = outMatrix(:,s);
    y = y + output;
    hop = floor(gLen/2);
end


%% Normalization 
y = y/max(abs(y));

%% Graphs
% 
% %Graphs for initial grains
% figure; plot(grainMatrix);
% 
% %Graphs for Grain Envelopes
% figure; plot(grainEnvMatrix);
% 
% %Graphs for Stochastic Output Matrix
% figure; plot(timeMatrices);
% 
% Graph for input vs output
xLen = abs(length(in)-outLengthN)
x = [in;zeros(xLen,1)];
figure; 
plot(x); hold on 
plot(y); hold off