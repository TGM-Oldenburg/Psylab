% user-script for melody_recognition.m
%
% Usage:  melody_recognitionuser
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

% generate current teststimulus, depending on current paramter (M.PARAM(1) = pitchtype)
% and current var (M.VAR = random number of melody)
M.LEVEL     = 70;
len         = 0.30;     % len of each tone in s
pauselen    = 0.10;     % pause between two tones in s
curr_pitch  = M.PARAM(1); % get current pitch-type
% generate current stimulus by generatePitchMelody()
m_test      = generatePitchMelody(curr_pitch, my_melodies(M.VAR).freq, M.LEVEL - M.CALIB, len, pauselen, M.FS);

% End of file:  melody_recognitionuser.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
