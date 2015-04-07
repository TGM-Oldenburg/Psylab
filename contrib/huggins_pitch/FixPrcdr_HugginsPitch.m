% Huggins pitch detection experiment using a fixed procedure. Measures
% several points on the psychometric function (%correct).
% Usage: FixPrcdr_HugginsPitch
%
% Copyright (C) 2007  Georg Stiefenhofer
% Author :  Georg Stiefenhofer
% Date   :  11.11.2007

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


% ------------------------------ set M.* variables
M.EXPNAME      = mfilename;    % experiment name, very important to be set correctly!
M.NUM_PARAMS   = 1;            % number of parameters
M.PARAMNAME(1) = {'Huggins_pitch_frequency'};
M.PARAMUNIT(1) = {'Hz'};
M.VARNAME      = 'Percent_correct';
M.VARUNIT      = '%';
M.TASK         = 'In which interval you could hear a tone (1,2)?  ';
M.NAFC         = 2 ;    % number of forced choice intervals
M.FIX_PROCDR = 1 ;      % 1 = do a fixed (level) procedure
M.FIX_ALLVARS   = [80 125 200 315 500 800 1250 2000] ; % fixed instances 
M.FIX_TRIALS = 10;      % trials per fixed instance
M.FIX_RANDVARS = 1;     % randomize presentation instances (1=randomize, 0=do not randomize)
M.FEEDBACK     = 0 ;    % 1/0  = yes/no
% ------------------------------ 
M.FS           = 48000; % sampling frequency
M.CALIB        = 100;   % means: a full-scale square wave has THIS dB SPL
M.USE_GUI      = 1;
M.DEBUG        = 0;
M.VISUAL_INDICATOR = 1;
M.EARSIDE = M_BINAURAL;

clc;  
type FixPrcdr_HugginsPitch.txt
M.SNAME = input('\n\n please type your name (initials, no spaces, press RETURN at end) ','s');

%% ==================================================

M.PARAM(1) = M.FIX_ALLVARS(1); % NOTE: uses existing PSYLAB framework
                               % with some modifications.
mpsy_FixPrcdr_afc_main;
mpsy_plot_result;

