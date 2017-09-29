% Measurement of intensity-JND for Sinusoids as a function of Frequency
%
% Usage: jnd_intensity
%
% Copyright (C) 2003       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  26 Jun 2005
% Updated:  <26 Jun 2005 14:19, mh>

%% This file makes use of PSYLAB, a collection of scripts for
%% designing and controling interactive psychoacoustical listening
%% experiments.  See http://www.hoertechnik-audiologie.de/psylab/
%%
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl


mpsy_init

% ------------------------------ set M.* variables
M.EXPNAME      = mfilename;    % experiment name, very important to be set correctly!
M.NUM_PARAMS   = 2;            % number of parameters
M.PARAMNAME(1) = {'reference_level'};
M.PARAMUNIT(1) = {'dB'};
M.PARAMNAME(2) = {'tone_frequency'};
M.PARAMUNIT(2) = {'Hz'};
M.VARNAME      = 'level_increment';
M.VARUNIT      = 'dB';
M.TASK         = 'which interval contained the test signal (1,2,3)?  ';
M.MINSTEP      = 0.25 ; % minumum step size, in units of M.VARUNIT
M.NAFC         = 2 ;    % number of forced choice intervals
M.ADAPT_METHOD = '1up_2down'; 
% M.ADAPT_METHOD = 'uwud';
% M.PC_CONVERGE  = 0.75;
M.MAXREVERSAL  = 8 ;    % number of reversals required as stop criterion
M.FEEDBACK     = 1 ;    % flag for provision of feedback about correctness of answer

% ------------------------------ 
M.FS               = 48000; % sampling frequency
M.CALIB            = 100;   % means: a full-scale square wave has THIS dB SPL
M.USE_GUI          = 1;
M.VISUAL_INDICATOR = 1;     % flag whether to use visual interval indication
M.DEBUG            = 0;


% set sound card to maximum output (!)

fprintf('\n\n\n\n');  
type jnd_intensity_instruction.txt

M.SNAME = input('\n\n please type your name (initials, no spaces, press RETURN at end) ','s');

% ==================================================
M.PARAM(2)  =  1000;

%ref_levels = -30;
ref_levels = [-70 -60 -50 -40 -30 -20 ];
for level = ref_levels,
   
  M.PARAM(1) = level;
  mpsy_afc_main;
 
end
mpsy_plot_thresholds;


% ==================================================
% M.PARAM(2)  = 2000;
% 
% for level = ref_levels,
%    
%   M.PARAM(1) = level;
%   mpsy_afc_main;
%  
% end
% mpsy_plot_thresholds;


% End of file:  jnd_intensity.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
