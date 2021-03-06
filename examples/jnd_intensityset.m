% set-script for jnd_intensity.m
%
% Usage:  jnd_intensityset
%
% Copyright (C) 2003       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  26 Jun 2005
% Updated:  <26 Jun 2005 14:32, mh>

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

M.VAR  = 8 ;    % start level increment (in dB)
M.STEP = 4 ;    % start STEP-size (also in dB)

tdur   = 0.4;    % duration of the tone [s]
a0     = sqrt(2)*10^(M.PARAM(1)/20);    % its amplitude

% pre-generate the sinusoid here
ton = gensin(M.PARAM(2), a0, tdur, 0, M.FS);
% apply hanning flanks
ton = hanwin(ton, round(0.05*M.FS));


% quiet-signals
pauselen  = 0.2;
m_quiet   = zeros(round(pauselen*M.FS),1);
m_postsig = m_quiet(1:end/2);
m_presig  = m_quiet;



% End of file:  jnd_intensityset.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
