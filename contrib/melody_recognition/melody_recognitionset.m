% set-script for melody_recognition.m
%
% Usage:  melody_recognitionset
%
% Copyright (C) 2007    Anika Baugart, Benjamin Ekwa, Sven Franz
% Author :  Anika Baugart, Benjamin Ekwa, Sven Franz
% Date   :  21 November 2007

%% This file makes use of PSYLAB, at collection of scripts for
%% designing and controling interactive psychoacoustical listening
%% experiments.  
%%
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

% preprocessing for the stimuli generation
my_melodies         = get_melodies('melodies.txt');     % load a struct of melody-data from file 'melodies.txt'
M.N_RECOGNITION     = length(my_melodies);              % get count of possible signals to recognize
M.COMPRARE_NAMES    = {my_melodies.name};               % get names of signals/melodies

% End of file:  melody_recognitionset.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
