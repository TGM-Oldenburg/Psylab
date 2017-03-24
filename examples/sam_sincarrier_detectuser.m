% user-script belonging to sam_sincarrrier_detect.m
%
% Usage:  sam_sincarrrier_detectuser
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


% copy the ramped ones-offset template signal mod1, which was
% generated in the set-script:
modulator = mod1;
% add the current sinusoidal modulator at the pre-calculated
% temporal position:
modulator(nsamp_mod_idx) = modulator(nsamp_mod_idx) + 10^(M.VAR/20)*sam;

% reference signal has no modulation, but only onset and offset ramps
m_ref  =  carrier .* mod1;
% test signal has extra modulation, with own onset and offset ramps
m_test =  carrier .* modulator;

% The next line is useful and necessary IN THIS example where
% modulation detection is investigated.  However, it will probably not
% be required in your experiment.  It may even be contra-productive
% or wrong in your own experiment!
% Equalize test signal and reference signal in RMS level:
m_test = m_test / rms(m_test) * rms(m_ref);


% End of file:  sam_sincarrrier_detectuser.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
