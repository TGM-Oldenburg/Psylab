% Usage: mpsy_debug_savefile
% ----------------------------------------------------------------------
%      Save all variables M* into a file for debugging purposes
%
%      This file gets called from mpys_afc_*main in case M.DEBUG>0
%
%   input args:  (none) works on set of global variables M.* 
%  output args:  (none) a file with saved workspace variables is generated
%
% Copyright (C) 2019 by Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  11 Feb 2019
% Updated:  <>

%% This file is part of PSYLAB, a collection of scripts for
%% designing and controlling interactive psychoacoustical listening
%% experiments.  
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.  See the GNU General
%% Public License for more details:  http://www.gnu.org/licenses/gpl
%% This file is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


% this functionality was earliear located inside the functions
% mpsy_proto_adapt.m and mpsy_proto_conststim.m

% also save the date into M:
M.DATE = datestr(now);

% setup filename with date/time info for saving in matlab format
m_filenamedate = ['psy_' M.SNAME '_'];
dv=datevec(now);
for k=1:3,
  m_filenamedate = [ m_filenamedate sprintf('%2.2d',mod(dv(k),100)) ];
end
% add current hour to end of filename
m_filenamedate = [ m_filenamedate '-' sprintf('%2.2d',dv(4))];
% now save it:
save(m_filenamedate, 'M', 'M_*')




% End of file:  mpsy_debug_savefile.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
