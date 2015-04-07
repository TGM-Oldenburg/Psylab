% user-script for  FixPrcdr_HugginsPitch.m
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



fb = M.VAR; % get the current center frequency
b = 0.16*fb;% calculate bandwidth 
f1 = fb-b/2;% lower edge freq
f2 = fb+b/2;% upper edge freq

dur = 0.5;
x = 2*(rand(M.FS*dur,1)-.5); % creat noise;
if abs(x)>1
    x = x/(max(abs(x)));
    disp('Normalized');
end


Post4000 = fft_rect_filt(x,0,4000, M.FS); % lowpass @ 4000Hz 

X = fft(Post4000); 
N = length(X);
m_ref = hanwin(Post4000, 0.03*M.FS); % reference signal
m_ref = [m_ref(:) m_ref(:)];         % make stereo  

% calculation of spectral index:  
idx1 = 1+floor(N * f1/M.FS) ;
idx2 = 1+floor(N * f2/M.FS) ;
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
m_test = hanwin(real(ifft(X)), 0.03*M.FS);
m_test = [m_ref(:,1) m_test(:)]; % stereo, forced column vector





