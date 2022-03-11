% textureDescriptionTest.m

[in,Fs] = audioread('water.wav');
in = in(1:239040,1); % make it easy multiples

%% Initial Pre-computing

%% Energy Envelope
%filter option of low-pass with a cutoff of 5Hz
% [b,a] = butter(4,(5/24000),'low');
% y = filter(b,a,in);
% nrgEnv = envelope(y,100,'rms');
nrgEnv = envelope(in,100,'rms');

%% Fourier Transforms
lenin = length(in);
winSize = 0.06*Fs;
win = hanning(winSize);

hopSize = 0.02*Fs;
strt = 1;
nend = winSize;
numframes = floor((lenin-winSize+hopSize)/hopSize);


fftFrame = (in(1:winSize,1));
for n = 2:numframes
    
    fftFrame = in(strt+(hopSize*(n-1)):nend+(hopSize*(n-1)),1);
    fftFrame = fft(fftFrame);
    
end

