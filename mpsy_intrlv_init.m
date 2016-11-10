% Usage: mpsy_intrlv_init
%
%  will be called from mpsy_intrlv_afc_main or mpsy_intrlv_match_main
%  at the beginning of a new interleaved-tracks experiment
%
%  Clears history of past run(s) (i.e. set M.REVERSAL, M.VARS,
%  M.STEPS, M.ANSWERS, M.REV_IDX to zero or to empty vectors) by a
%  separate call to mpsy_init_run for each of the interleaved tracks.
%  Sets some variables to default values.
% 
%   input:   (none), works on global variables
%  output:   (none) 
%
% Copyright (C) 2007   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  10 Apr 2007
% Updated:  < 8 Apr 2013 08:42, martin>
% Updated:  < 7 Mai 2010 21:14, hansen>
% Updated:  <17 Apr 2007 00:28, hansen>

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



% check whether we have an experiment with at least 2 interleaved
% runs.  Note that M will have length(M) == 1 later on.
if length(M) < 2,
  error('less than two interleaved runs makes no sense.  Use non-interleaved mode instead');
else

  % prepare and initialize interleaved-setup:
  % copy M to MI  ("M INTERLEAVED") ...
  MI = M;
  % ... and clear variable M
  clear M;

  % have one extra special struct M1 with a few common infos
  M1.NUM_INTERLEAVED_TRACKS = length(MI);
  
  % setup new flag variable indicating whether a run has been completed:
  M1.TRACKS_COMPLETED = zeros(M1.NUM_INTERLEAVED_TRACKS, 1);
end


% Now fill any empty fields in elements of MI(2:end) with
% contents of MI(1), and also check size/types of fields VAR, STEP, PARAM
psize = size(MI(1).PARAM);
for k=2:M1.NUM_INTERLEAVED_TRACKS,
  % fill empty fields:
  mfields = fieldnames(MI(k));
  for l=1:length(mfields),
    thisfield = char(mfields(l));
    if isempty(MI(k).(thisfield)),
      MI(k).(thisfield) =   MI(1).(thisfield);
    end
  end
  
  % check sizes/types:
  if ~isnumeric(MI(k).PARAM),
    error('content of field M.PARAM must be numeric.');
  end
  if any(size(MI(k).PARAM) ~= psize),
    error('size of field PARAM of all elements of MI must be identical.');
  end
end

% Then reset some internal variables.  
% We use the existing mpsy_init_run.m for this task.  It sets field
% variables of the reserved name variable M. 
for k=1:M1.NUM_INTERLEAVED_TRACKS,
  % The reserved name variable M1.cur_track_idx is 
  % later needed by mpsy_intrlv_puttrack   
  M1.cur_track_idx = k;
  M = MI(k);
  % then initialize this current M
  mpsy_init_run;
  % use existing mpsy_intrlv_puttrack.m to fill (partly new) field
  % values of M back into MI 
  mpsy_intrlv_puttrack
end


% initialize some fields in order to maintain common fields of all
% elements of MI 
for k=1:M1.NUM_INTERLEAVED_TRACKS,
  MI(k).VAR        = [];
  MI(k).STEP       = [];
  %%MI(k).UA         = [];
  MI(k).ACT_ANSWER = [];
end




% End of file:  mpsy_intrlv_init.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
