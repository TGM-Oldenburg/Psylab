% Usage: mpsy_visual_interval_indicator
% ----------------------------------------------------------------------
%    to be called from mpsy_afc_main
%
%   input:   (none), depends on global variables
%  output:   (none), changing color of buttons on response GUI
%
% Copyright (C) 2005 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  03 Nov 2005
% Updated:  < 1 Nov 2011 09:05, martin>
% Updated:  < 3 Nov 2005 15:05, hansen>

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


% For the visual interval indication scripts to work, it is REQUIRED
% that both reference signal and test signal have the same duration.
% So, perform the corresponding check, (and possibly set/override
% M.VISUAL_INDICATOR = 0)
mpsy_visual_interval_check;


dur_presig   = size(m_presig,1)/M.FS;  % duration of pre-signal
dur_postsig  = size(m_postsig,1)/M.FS; % duration of post-signal
dur_quiet    = size(m_quiet,1)/M.FS;   % dur. of quiet pause between intervals


%c_tmp = get(afc_but(1), 'BackgroundColor');   % store the normal color
c_tmp = 0.8*[1 1 1];

pause(dur_presig);

set(afc_but(1), 'BackgroundColor', [1 0 0]);  % RED
pause(dur_interval);
set(afc_but(1), 'BackgroundColor', c_tmp);    % back to normal

for kk=1:M.NAFC
  pause(dur_quiet);

  set(afc_but(kk), 'BackgroundColor', [1 0 0]);  % RED
  pause(dur_interval);
  set(afc_but(kk), 'BackgroundColor', c_tmp);    % back to normal
end

pause(dur_postsig);

  

% End of file:  mpsy_visual_interval_indicator.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
