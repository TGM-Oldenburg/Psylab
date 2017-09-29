% user-script for jnd_frequency.m
%
% Usage:  jnd_frequencyuser
%
% Copyright (C) 2003       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  26 Jun 2005
% Updated:  <26 Jun 2005 18:02, mh>

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

% make shure we always have an INCREMENT in frequency.  
if M.VAR < 0,
  warning(' M.VAR < 0 detected.  Set to M.VAR=0;');
  M.VAR = 0;    % force guessing
end

% sinusoid
ton2 = gensin(M.PARAM(1) * 2^(M.VAR/1200), a0, tdur, 0, M.FS);
% hanning flanks
m_test = hanwin(ton2, round(0.05*M.FS));



% End of file:  jnd_frequencyuser.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
