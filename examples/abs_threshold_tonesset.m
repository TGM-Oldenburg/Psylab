% set-script for abs_threshold_tones.m
%
% Usage:  abs_threshold_tonesset
%
% Copyright (C) 2006       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  16 May 2006
% Updated:  <16 Mai 2006 17:01, hansen>

%% This file makes use of PSYLAB, a collection of scripts for
%% designing and controling interactive psychoacoustical listening
%% experiments.   See http://www.hoertechnik-audiologie.de/psylab/
%%
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

M.VAR  = -30 ;  % start level increment (in dB)
M.STEP = 8 ;    % start STEP-size (in dB)

tdur   = 0.5;    % duration of the tone [s]

% generate a sinusoid with RMS = 1, i.e. with amplitude sqrt(2)
ton = gensin(M.PARAM(1), sqrt(2), tdur, 0, M.FS);
% hanning flanks
ton = hanwin(ton, round(0.05*M.FS));


% pause-signals
m_quiet   = 0.2;
m_postsig = m_quiet;
m_presig  = m_quiet;



% End of file:  abs_threshold_tonesset.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
