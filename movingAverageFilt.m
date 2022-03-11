% movingAverageFilt.m

function [g] = movingAverageFilt(in)


Xhilbert = hilbert(in);
Xp = conj(Xhilbert);
gp = sqrt(Xhilbert.*Xp);
gp = [zeros(50,1); gp ; zeros(50,1)];

Ls = 100;
lsa = Ls/2;
strt= lsa+1;
lenIn = length(in);

g = zeros(lenIn,1);

%Moving average filter to smooth envelope
for t = strt:lenIn
    %average filter (100)
    g(t,1) = (1/Ls)*sum(gp(t-lsa:t+lsa,1));
end
% Output is an array g[n] which is the averaged filter coefficients for a
% given grain