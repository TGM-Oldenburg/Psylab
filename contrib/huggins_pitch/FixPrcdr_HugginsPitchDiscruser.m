% user-script for  FixPrcdr_HugginsPitchDiscr.m
%
% Usage:   FixPrcdr_HugginsPitch
%
% Copyright (C) 2007       G.Stiefenhofer
% Author :    G.Stiefenhofer
% Date   :  November 2007

%% This file makes use of PSYLAB, at collection of scripts for
%% designing and controling interactive psychoacoustical listening
%% experiments.
%%
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License,
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl


freq = M.VAR; % get the current center frequency
pitchincr = .09; % frequency increment in %/100
freqs = [M.VAR*(1-pitchincr) M.VAR M.VAR*(1+pitchincr) ]; % compute HugginsPitches at these 3 frequencies
dur = 0.5; % duration 500 ms
x = 2*(rand(M.FS*dur,1)-.5); % same noise for all 3 frequencies
if abs(x)>1
    x = x/(max(abs(x)));
    disp('Normalized');
end
Post4000 = fft_rect_filt(x,0,4000, M.FS); % lowpass @ 4000Hz
X = fft(Post4000);                          
N = length(X);
NoiseOrig = hanwin(Post4000, 0.03*M.FS);
Huggins = zeros(N,2,3);
for kk = 1:3
    X_new = X(1:N/2);    % use only half of the spectrum, as it is conjugate symmetric
    fb = freqs(kk);
    b = 0.16*fb;         % calculate bandwidth
    f1 = fb-b/2;         % lower edge freq
    f2 = fb+b/2;         % upper edge freq

    % calculation of spectral index:   
    idx1 = 1+floor(N * f1/M.FS) ;
    idx2 = 1+floor(N * f2/M.FS) ;

    % computes absolute value and angle of X_new for desired band (idx1:idx2)
    R = abs(X_new(idx1:idx2));
    theta = angle(X_new(idx1:idx2));
    
    % linear shifting from 0...2pi
    shift = linspace(0,2*pi,idx2-idx1+1)';
    theta = theta + shift;

    % apply new phase to desired band
    PostPhaseShift = R.*exp(i*theta);
    X_new(idx1:idx2) = PostPhaseShift;

    % window and ifft.
    % NOTE: use attribute 'symmetric' to ensure correct output. Phase
    % changes were performed only in band [0...fs/2] and not in [fs/2...fs].
    % Assume X_new to be conjugate symmetric.
    NoisePhaseShift = hanwin(ifft(X_new,N,'symmetric'), 0.03*M.FS);
    Huggins(:,:,kk) = [NoiseOrig NoisePhaseShift]; % stereo, forced column vector
end
% mount the signals
% NOTE: 2 test signals, where only one is used per trial, i.e. it's
% randomly choosen, if at the current trial the test signal will be higher,
% equal or lower in pitch.
m_test1 = Huggins(:,1:2,1); % 9% lower pitch than m_ref
m_ref   = Huggins(:,1:2,2);
m_test2 = Huggins(:,1:2,3); % 9% higher pitch than m_ref

