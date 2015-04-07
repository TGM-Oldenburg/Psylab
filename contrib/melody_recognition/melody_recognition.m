% Measurement of melody recognition using three types of dichotic-pitch stimulus
%
% Usage: melody_recognition
%
% Copyright (C) 2007    Anika Baugart, Benjamin Ekwa, Sven Franz
% Author :  Anika Baugart, Benjamin Ekwa, Sven Franz
% Date   :  21 November 2007
%
% Reference:  Akeroyd et al., Jasa 110(3), 1498-1504, 2001.

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

mpsy_init;

% ------------------------------    set M.* variables
M.EXPNAME           = mfilename;    % experiment name, very important to be set correctly!
M.NUM_PARAMS        = 1;            % number of parameters
M.PARAMNAME         = {'pitch_type'};
M.PARAMUNIT         = {'No'};
M.VARNAME           = 'melody_no';
M.VARUNIT           = 'No';
M.TASK              = 'which melody was played?';
M.N_RECOGNITION      = 0;           % count of possible signals to recognize (will be set in "melody_recognitionset.m")
M.COMPRARE_NAMES    = {};           % names of signales (count number of names >= M.N_RECOGNITION) (will be set in "melody_recognitionset.m")
M.COMPAREWITHNONE   = 1;            % 0/1 = yes/no : button "not recognized" displayed?
M.LOOPS             = 1;            % count of loops through all possible stimuli
M.FEEDBACK          = 1 ;           % 1/0  = yes/no

% ------------------------------ 
M.FS                = 48000;        % sampling frequency
M.CALIB             = 100;          % means: a full-scale square wave has THIS dB SPL
M.USE_GUI           = 1;            % 1/0  = yes/no
M.DEBUG             = 0;            % 1/0  = yes/no
M.VISUAL_INDICATOR  = 1;            % 1/0  = yes/no

clc; 
pause(0.1);
type melody_recognition_instruction.txt

pause(0.1);
M.SNAME = input('\n\n please type your name (initials, no spaces, press RETURN at end) ','s');

M.PARAMS = {'puretone', 'huggins', 'binauraledgepitch', 'bicep'}; % realnames of parameter 'pitch_type'
for pitch = 1 : length(M.PARAMS) % loops through all parameters
    M.PARAM(1) = pitch;
    mpsy_recognition_main;
end

% End of file:  melody_recognition.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
