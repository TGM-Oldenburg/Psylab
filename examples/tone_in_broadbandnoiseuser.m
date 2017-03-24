% user-script belonging to tone_in_broadbandnoise.m
%
% Usage:  tone_in_broadbandnoiseuser
%
% Copyright (C) 2007       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  14 Jun 2007
% Updated:  <17 Mar 2017 15:05, mh>     -- use of 3 independent noises
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


% generate 3 new instances of running broadband noise
noise = randn(round(noise_dur*M.FS),3);
% adjust its level
for kk=1:3,
  noise(:,kk) = noise(:,kk)/rms(noise(:,kk))*10^(M.PARAM(2)/20);
end
% apply onset/offset ramps
noise = hanwin(noise, round(ramp_dur*M.FS));

% Generate sinusoidal tone.  Always generate the sinusoid HERE again
% (instead of simple scaling of a sinusoid pre-generated in the
% set-script), because this is an interleaved(!) experiment, and hence
% the tone frequency in M.PARAM(1) can change from trial to trial
tone = gensin(M.PARAM(1), sqrt(2)*10^(M.VAR/20), tone_dur, 0, M.FS);
tone = hanwin(tone, round(ramp_dur*M.FS));

% assign the 3 noises to m_ref1, m_ref2, m_test
m_ref1 = noise(:,1);
m_ref2 = noise(:,2);
m_test = noise(:,3);

% add tone temporally centered in the noise of test interval
m_test(start_idx:end_idx) = m_test(start_idx:end_idx) + tone;



% End of file:  tone_in_broadbandnoiseuser.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
