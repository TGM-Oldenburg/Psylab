% Usage: y = mpsy_intrlv_gettrack
% ----------------------------------------------------------------------
%
%          This script is used by mpsy_intrlv_afc_main.m for AFC
%          experiments with interleaved tracks.  It extracts the field
%          variables of one particular run from the storage variable
%          'MI' for all runs and copies it to the reserved-name
%          variable 'M'.  
%
%
% Copyright (C) 2007 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  03 Apr 2007
% Updated:  <17 Apr 2007 00:27, hansen>

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


% find a random track index among those tracks not yet completed:
idx_running_tracks  = find(M1.TRACKS_COMPLETED == 0);
rand_tmp_idx        = randperm (length(idx_running_tracks));
M1.cur_track_idx    = idx_running_tracks(rand_tmp_idx(1));

% now copy the current track's data into reserved-name variable M
M = MI(M1.cur_track_idx);


% End of file:  mpsy_intrlv_gettrack.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
