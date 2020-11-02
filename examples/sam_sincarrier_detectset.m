% set-script belonging to sam_sincarrrier_detect.m
%
% Usage:  sam_sincarrrier_detectset
%
% Copyright (C) 2003       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  3 Apr 2005
% Updated:  < 8 Nov 2005 23:15, mh>

%% This file makes use of PSYLAB, a collection of scripts for
%% designing and controling interactive psychoacoustical listening
%% experiments.  See http://www.hoertechnik-audiologie.de/psylab/
%%
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

MYVAR = 0;

M.VAR  = -8 ;    % start modulations degree (in dB)
M.STEP =  4 ;    % start STEP-size, same unit as M.VAR

tdur   = 0.8;    % duration of the carrier [s]
a0     = 0.5;    % its amplitude
moddur = 0.6;    % duration of the modulation [s]


if M.PARAM(2) == -1,
  disp('semi-frozen broad band noise carrier instead of sinusoid carrier')
  carrier =  0.1*randn(round(tdur*M.FS),1);
else
  carrier = gensin(M.PARAM(2), a0, tdur, 0, M.FS);
end

% the "ones-offset" of the modulator with 150ms Hanning window
mod1 = ones(size(carrier));
mod1 = hanwin(mod1, round(0.15*M.FS));

% sinusoidal-modulator with amplitude 1,
sam  = gensin(M.PARAM(1), 1, moddur, 0, M.FS);
sam = hanwin(sam);   % with full length hanning window 
% sam = hanwin(sam, round(0.05*M.FS));  % or only 50 ms ramp length

% temporal structure of the modulator:
% here illustrated for shorter onset ramps:
% 50 ms carrier onset ramp and 50 ms modulation onset ramp
% 
%                          ---------------------
%                         /     modulation      \ 
%                   -----.                       .-----
%                 ./ ones                         ones \.
%                        |<... nsamp_mod_idx ...>|
%
% start sample number for start of the modulation
nsamp_mod_start = round(M.FS*(0.5*(tdur-moddur)));
% all sample indices for modulation-part
nsamp_mod_idx = nsamp_mod_start+(1:length(sam))';



% quiet signals
pauselen  = 0.2;
m_quiet   = zeros(round(pauselen*M.FS),1);
m_postsig = m_quiet(1:end/2);  
m_presig  = m_quiet;



% add some overall background signal:  a low level white noise
%
% Note: This background noise is NOT part of the original experiment by
% Kohlrausch et al. (2000).  It is added here for demostration purposes only

% generate a signal template with the size of the final output signal
tmp_outsig = [m_presig; carrier; m_quiet; carrier; m_quiet; carrier; m_postsig];
% generate a noise with that duration
rms_background_noise = 0.001;
m_background = hanwin( rms_background_noise*randn(size(tmp_outsig)), 0.05*M.FS);
% clear the template signal as it is not needed anymore
clear tmp_outsig;



% End of file:  sam_sincarrrier_detectset.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
