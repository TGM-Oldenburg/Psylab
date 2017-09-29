% set-script for match_freq_binaural_singletrack
%
% Usage: match_freq_binaural_singletrackset
%
%
% Copyright (C) 2012 by Martin Hansen, Jade Hochschule
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  30 Nov 2012
% Updated:  <30 Nov 2012 10:39, martin>

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

M.VAR  = 33 ;    % start frequency increment factor
M.STEP = 16 ;    % start STEP-size 

tdur   = 0.4;    % duration of tone [s]
level  = -20;    % its level [dB FS]
a0     = sqrt(2)*10^(level/20);    % its amplitude

% sinusoid
ton1 = gensin(M.PARAM(1), a0, tdur, 0, M.FS);
% hanning flanks
ton1 = hanwin(ton1, round(0.05*M.FS));

% quiet signals
pauselen  = 0.2;
m_quiet   = zeros(round(pauselen*M.FS),2);
m_postsig = m_quiet;
m_presig  = m_quiet;



switch M.PARAM(2)
  case 1,
      M.TASK = 'for equal pitch, the left tone needs to go ...';
  case 2,
      M.TASK = 'for equal pitch, the right tone needs to go ...';
  otherwise, 
    error('wrong number in M.PARAM(2) (ear side of test signal), must be 1 or 2');
end


% End of file:  match_freq_binaural_singletrackset.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
