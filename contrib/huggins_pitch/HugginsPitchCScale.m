% This script runs the preliminary test similar to the one used in
% "Binaural pitch perception in normal-hearing and hearing-impaired
% listeners (2007)" by S.Santurette and T.Dau.

% Usage: HugginsPitchCScale.m
%
% Copyright (C) 2007       G.Stiefenhofer
% Author :  G.Stiefenhofer
% Date   :  December 2007

%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

FS = 48000;
FlanksDur = 0.03;
f1 = 523.25;
freqs = zeros(1,12);
for kk = 1:12
    freqs(kk) = f1*2^(kk/12);
end
freqs = [f1 freqs([2 4 5 7 9 11 12])]; % take only freqs of c-major scale (c5 d5 e5 f5 g5 a5 b5 c6)

for kk = 1:length(freqs)
fb = freqs(kk); % get the current center frequency
b = 0.16*fb;% calculate bandwidth 
f1 = fb-b/2;% lower edge freq
f2 = fb+b/2;% upper edge freq

dur = 1;
x = 2*(rand(FS*dur,1)-.5); % creat noise;
Post4000 = fft_rect_filt(x,0,4000, FS); % lowpass @ 4000Hz 

X = fft(Post4000); 
N = length(X);
m_ref = hanwin(Post4000, FlanksDur*FS); % reference signal
m_ref = [m_ref(:) m_ref(:)];            % make stereo  

% calculation of spectral index:   idx = 1+N*f/fs
idx1 = 1+floor(N * f1/FS) ;
idx2 = 1+floor(N * f2/FS) ;
idx3 = N - idx2 + 2;   
idx4 = N - idx1 + 2;   

% computes absolute value and angle off X for desired band (here idx1:idx2 
% AND idx3:idx4)
R = abs(X(idx1:idx2));
theta = angle(X(idx1:idx2));
R2 = abs(X(idx3:idx4));
theta2 = angle(X(idx3:idx4));

% linear shifting from 0...2pi
shift = linspace(0,2*pi,idx2-idx1+1)';
theta = theta + shift;
theta2 = theta2 + shift;

% apply new phase to desired band
PostPhaseShift = R.*exp(i*theta);
PostPhaseShift2 = R2.*exp(i*theta2);
X(idx1:idx2) = PostPhaseShift;
X(idx3:idx4) = PostPhaseShift2;

% window and ifft. NOTE: use only real part, because imag. part is slightly
% bigger than 0, i.e. somewhat around 10^-13.
m_test = hanwin(real(ifft(X)), FlanksDur*FS);
m_test = [m_ref(:,1) m_test(:)]; % stereo, forced column vector
CScaleHuggins(:,:,kk) = m_test;
end

Sign = zeros(FS,2,10);
Sign(:,:,2:9) = CScaleHuggins;
Sign(:,:,1) = m_ref;
Sign(:,:,10) = m_ref;

for kk = 1:10
    sound(Sign(:,:,kk),FS)
end




