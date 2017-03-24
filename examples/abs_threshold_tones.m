% Measurement of absolute threshold for sinusoids as a function of frequency
%
% Usage: abs_threshold_tones
%
% Copyright (C) 2006       Martin Hansen, Jade Hochschule
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  16 May 2006
% Updated:  <24 Mar 2017 11:24, mh>
% Updated:  <16 Mai 2006 16:53, hansen>

%% This file makes use of PSYLAB, a collection of scripts for
%% designing and controling interactive psychoacoustical listening
%% experiments.   See http://www.hoertechnik-audiologie.de/psylab/
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
M.NUM_PARAMS   = 1;            % number of parameters
M.PARAMNAME    = {'tone-frequency'};
M.PARAMUNIT    = {'Hz'};
M.VARNAME      = 'tone-level';
M.VARUNIT      = 'dB';
M.TASK         = 'which interval contained the test signal (1,2,3)?  ';
M.MINSTEP      = 1 ;    % minumum step size, in units of M.VARUNIT
M.NAFC         = 3 ;    % number of forced choice intervals
%
M.ADAPT_METHOD = 'wud';   % weighted up down
M.PC_CONVERGE  = 0.75;    % target probability for convergence
%
M.MAXREVERSAL  = 6 ;    % number of reversals required as stop criterion
M.FEEDBACK     = 1 ;    % flag for provision of feedback about correctness of answer

% ------------------------------ 
M.FS               = 48000; % sampling frequency
M.CALIB            = 100;   % means: a full-scale square wave has THIS dB SPL
M.USE_GUI          = 1;     % 1/0  = yes/no
M.VISUAL_INDICATOR = 1;     % flag whether to use visual interval indication
M.DEBUG            = 0;


% ========================================
M.USE_MSOUND       = 1;     % flag whether to use msound (1 or 0)
M.MSOUND_DEVID     = 0;     % device ID for msound (choose 0 or [] for default device)
M.MSOUND_FRAMELEN  = 1024;  % framelen for msound (number of samples)
M.MSOUND_NCHAN     = 1;     % number of channels, must match  size(m_outsig,2)

% set sound card to maximum output
% system('volumemax&');

fprintf('\n\n\n');  %%clc;  
type abs_threshold_instruction.txt

M.SNAME = input('\n\n please type your name (initials, no spaces, press RETURN at end) ','s');


% ==================================================
 
frequencies = [125 250 500 1000 2000 4000 8000];
for f0 = frequencies,
   
  M.PARAM(1) = f0;
  mpsy_afc_main;
  mpsy_plot_result;
 
end



% End of file:  abs_threshold_tones.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
