%outOrder.m
function [permutation,framesOut] = outOrder(outLengthS, Fs, gLen, numframes) 

gHop = floor(gLen/2);
outLengthN = outLengthS * Fs; %output length in samples


%find needed amt of overlapped grains to output the requested length in sec
framesOut = floor((outLengthN-gLen+gHop)/gHop);
frameDif = abs(framesOut-numframes);
permutation = randperm(framesOut)';

for n = 1:framesOut
     
    %index values for needed frames changing necessary ones
    if permutation(n,1) > numframes
       permutation(n,1) = permutation(n,1) - frameDif;
       if permutation(n,1) == 0
           permutation(n,1) = 2;
       end
    else
       permutation(n,1) = permutation(n,1);
    end
end
  