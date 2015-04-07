% Usage: y = mpsy_intrlv_puttrack
% ----------------------------------------------------------------------
%
%          This script is used by mpsy_intrlv_afc_main.m for AFC
%          experiments with interleaved tracks.  It stores the field
%          variables of one particular run, kept in reserved-name
%          variable 'M', back into the storage variable 'MI' for all
%          runs.
%
%
% Copyright (C) 2007 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  10 Apr 2007
% Updated:  <17 Apr 2007 00:27, hansen>
% Updated:  <10 Apr 2007 19:41, hansen>



% fill back all field entries (mainly interesting: those updated in
% the very recent trial) into storage variable MI

%%  the following line would not work in case that M had gotten
%%  more (i.e. newer) fields than previously stored in MI(M1.cur_track_idx) 
%%%%MI(M1.cur_track_idx) = M;

%%  instead, we have to take an explicit way of copying all fields
mfields = fieldnames(M);
for l=1:length(mfields),
  thisfield = char(mfields(l));
  MI(M1.cur_track_idx).(thisfield) =   M.(thisfield);
end




% End of file:  mpsy_intrlv_gettrack.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
