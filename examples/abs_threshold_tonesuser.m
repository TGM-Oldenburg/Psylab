% user-script for abs_threshold_tones.m
%
% Usage:  abs_threshold_tonesuser
%
% Copyright (C) 2003       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  26 Jun 2005
% Updated:  <16 Mai 2006 17:07, hansen>

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


if M.VAR > -3,
  warning('tone level limited to -3dB RMS to prevent clipping')
  M.VAR = -3;
end

m_ref  = ton * 0;
m_test = ton * 10^(M.VAR/20);


% End of file:  abs_threshold_tonesuser.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
