% set-script belonging to tone_in_broadbandnoise.m
%
% Usage:  tone_in_broadbandnoiseset
%
% Copyright (C) 2007       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  14 Jun 2007
% Updated:  <14 Jun 2007 12:22, hansen>

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

M.VAR  =  M.PARAM(2) ;    % start level of test tone
M.STEP =  8 ;     % start STEP-size, same unit as M.VAR

noise_dur = 0.4;   % duration of the noise
tone_dur  = 0.4;   % duration of the tone
ramp_dur  = 0.05;  % duration of onset and offset hanning ramps
pause_dur = 0.2;   % duration of inter stimulus interval


% calculate sample indices to place tone temporally centered in the noise
if tone_dur> noise_dur,
  error('noise should be equal or longer in duration than the tone');
end
start_idx = round((noise_dur-tone_dur)*M.FS/2)+1;
end_idx   = start_idx + round(tone_dur*M.FS)-1;


m_quiet = zeros(round(pause_dur*M.FS),1);

% End of file:  tone_in_broadbandnoiseset.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
