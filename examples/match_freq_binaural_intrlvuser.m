% user-script for match_freq_binaural_intlvr
%
% Usage: match_freq_binaural_intlvruser
%
% Copyright (C) 2012 by Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  30 Nov 2012
% Updated:  <30 Nov 2012 10:42, martin>

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


% sinusoid
ton2 = gensin(M.PARAM(1) * 2^(M.VAR/1200), a0, tdur, 0, M.FS);
% hanning flanks
ton2 = hanwin(ton2, round(0.05*M.FS));

switch M.PARAM(2)
  case 1,
    m_test = [ton2  0*ton2];   % test tone in column 1 (left)
    m_ref  = [0*ton1  ton1];
  case 2,
    m_test = [0*ton2  ton2];   % test tone in column 2 (right)
    m_ref  = [ton1  0*ton1];
  otherwise, 
    error('wrong number in M.PARAM(2) (ear side of test signal), must be 1 or 2');
end


% End of file:  match_freq_binaural_intlvruser.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
