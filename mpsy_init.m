% Usage: mpsy_init
%
%  to be called at the beginning of a new experiment
%
%   input:   (none), works on global variables
%  output:   (none) 
%
% Copyright (C) 2006   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  25 Okt 2006
% Updated:  < 8 Apr 2013 08:41, martin>
% Updated:  <25 Okt 2006 21:27, hansen>

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


fprintf('\n\n *** Start of a new experiment.  ALL psylab variables are now deleted. ***\n')

% clear variable M (and all its fields) belonging to PSYLAB (if any)
% also clear MI (storing individual runs' M for interleaved tracks)
clear M MI

% close the answer GUI, if one is present
tmp = findobj('Tag', 'psylab_answer_gui');
if ~isempty(tmp),
  close(tmp);
  % in case the existing figures gets closed, its DeleteFcn gets
  % called, which will set M.QUIT to 1.  
end

% reset overall quit-flag, indicating a quit of the whole experiment
% This needs to be done AFTER an existing psylab gui has been deleted. 
M.QUIT  = 0;     

% clear all gui handles pertaining to the answer GUI and all
% possibly existing signal like m_quiet, m_test etc. 
clear afc_* m_* 


% values for M.EARSIDE:  only left, only right or binaural
global M_BINAURAL
M_BINAURAL  = 0;   % 1. possible value of M.EARSIDE, predefined value
global M_LEFTSIDE
M_LEFTSIDE  = 1;   % 2. possible value of M.EARSIDE, predefined value
global M_RIGHTSIDE
M_RIGHTSIDE = 2;   % 3. possible value of M.EARSIDE, predefined value

% values for M.DIRECTION:   direction of last change of M.VAR
global M_UP
M_UP        =  1;   % 1. possible value of M.DIRECTION, predefined value
global M_DOWN
M_DOWN      = -1;   % 2. possible value of M.DIRECTION, predefined value
global M_STAY
M_STAY      =  0;   % 3. possible value of M.DIRECTION, predefined value


% values for M.MODE
global M_LISTENER
M_LISTENER = 1;    % 1. possible value of M.MODE, meaning:  listening test with subject
global M_SIMULATION
M_SIMULATION = 2;    % 2. possible value of M.MODE, meaning:  simulation via model

% let these variables exist, needed by mpsy_info.m
afc_fb   = [];
afc_info = [];

  



% End of file:  mpsy_init.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
