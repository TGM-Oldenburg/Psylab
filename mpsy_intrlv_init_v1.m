% Usage: mpsy_intrlv_init
%
%  to be called at the beginning of a new interleaved-tracks experiment
%
%  clears history of past run (i.e. set M.REVERSAL, M.VARS, M.STEPS,
%  M.ANSWERS, M.REV_IDX, M.VAR_LOWLIMIT, M.VAR_HIGHLIMIT  
%  to zero or to empty vectors).
%  sets some variables to default values.
% 
%   input:   (none), works on global variables
%  output:   (none) 
%
% Copyright (C) 2007   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  10 Apr 2007
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



% clear reference and test signal, as a security means
clear m_test m_ref* 

% clear some internal variables 
% NOTE:  mpsy_proto and mpsy_plot_feedback depend on this !
clear *_thres 


% check whether we have an experiment with interleaved runs and
% this is the very first trial 
if length(M) < 2,
  error('less than two interleaved runs makes no sense.  Use non-interleaved mode instead');
else

  % prepare and initialize interleaved-setup:
  % copy M to MI  ("M INTERLEAVED") ...
  MI = M;
  % ... and clear variable M
  clear M;
  
  
% $$$   % use first element of MI as a reference, as this will contain
% $$$   % all common information (variable name and unit, parameter names
% $$$   % and units, etc.)
% $$$   M1 = MI(1);
  M1.NUM_INTERLEAVED_TRACKS = length(MI);
  
  % setup new flag variable indicating whether a run has been completed:
  M1.TRACKS_COMPLETED = zeros(M1.NUM_INTERLEAVED_TRACKS, 1);
end

  % set some variables to default-values, if not yet present
  if ~isfield(MI(1), 'TASK')
    MI(1).TASK = '';
  end
  if ~isfield(MI(1), 'EARSIDE'),
    MI(1).EARSIDE = M_BINAURAL;
    % fprintf('*** Info: (%s)  M.EARSIDE has been set to M_BINAURAL\n', mfilename);
  end
  if ~isfield(MI(1), 'RESULTSTYLE'),
    MI(1).RESULTSTYLE = 1;   % all plots into one 
  end
  if ~isfield(MI(1), 'USE_GUI'),
    MI(1).USE_GUI = 0;
  end
  if ~isfield(MI(1), 'VISUAL_INDICATOR'),
    MI(1).VISUAL_INDICATOR = 0;
  end
  if ~isfield(MI(1), 'INFO'),
    MI(1).INFO = 1;
  end
  if ~isfield(MI(1), 'FEEDBACK'),
    MI(1).FEEDBACK = 1;
  end
  if ~isfield(MI(1), 'DEBUG'),
    MI(1).DEBUG = 0;
  end

  if ~ispc & MI(1).VISUAL_INDICATOR,
    MI(1).VISUAL_INDICATOR = 0;
    disp('*** info:  The VISUAL_INDICATOR feature is not yet supported on non-pcwin computers');
  end

% fill any empty fields in elements of MI(2:end) with contents of MI(1), 
% check size/types of fields VAR, STEP, PARAM
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

% clear history of past runs, initialize with proper values
for k=1:M1.NUM_INTERLEAVED_TRACKS,
  MI(k).REVERSAL  = 0;
  MI(k).VARS      = [];
  MI(k).STEPS     = [];
  MI(k).ANSWERS   = [];
  MI(k).REV_IDX   = [];
  MI(k).DIRECTION = [];
  
  % initialize these in order to maintain common fields of all elements of MI
  MI(k).VAR        = [];
  MI(k).STEP       = [];
  MI(k).UA         = [];
  MI(k).ACT_ANSWER = [];
end




% End of file:  mpsy_intrlv_init.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
