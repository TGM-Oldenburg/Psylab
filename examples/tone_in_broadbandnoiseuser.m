% user-script belonging to tone_in_broadbandnoise.m
%
% Usage:  tone_in_broadbandnoiseuser
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


% generate new instance of running noise
m_ref = randn(round(noise_dur*M.FS),1);
% adjust its level
m_ref = m_ref/rms(m_ref)*10^(M.PARAM(2)/20);
% apply onset/offset ramps
m_ref = hanwin(m_ref, round(ramp_dur*M.FS));

% generate sinusoidal tone.  always generate the sinusoid again HERE
% (instead of simple scaling of a sinusoid pre-generated in the
% set-script), because this is an interleaved(!) experiment.
tone = gensin(M.PARAM(1), sqrt(2)*10^(M.VAR/20), tone_dur, 0, M.FS);
tone = hanwin(tone, round(ramp_dur*M.FS));

% place tone temporally centered in the noise
m_test = m_ref;
% add tone
m_test(start_idx:end_idx) = m_test(start_idx:end_idx) + tone;




% End of file:  tone_in_broadbandnoiseuser.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
