% Measurement of binaural frequency-matching for sinusoids as a function of Frequency
%
% Usage: match_freq_binaural_singletrack
%
% Copyright (C) 2006       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  31 Okt 2006
% Updated:  <29 Aug 2017 11:28, martin>
% Updated:  <23 Apr 2013 16:21, martin>
% Updated:  <31 Okt 2006 16:13, hansen>

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


mpsy_init;

% ------------------------------ set M.* variables
M.EXPNAME      = mfilename;    % experiment name, very important to be set correctly!
M.NUM_PARAMS   = 3;            % number of parameters
M.PARAMNAME(1) = {'reference_frequency'};
M.PARAMUNIT(1) = {'Hz'};
M.PARAMNAME(2) = {'test_ear_side'};
M.PARAMUNIT(2) = {'left1_right2'};
M.PARAMNAME(3) = {'target_p_correct'};
M.PARAMUNIT(3) = {'percent'};
M.VARNAME      = 'rel_frequency_increment';
M.VARUNIT      = 'cent';
% %% M.TASK         = 'match the tones in frequency';   % TASK gets set in the set-script!
M.MINSTEP      = 1 ;   % minumum step size, in units of M.VARUNIT
M.MATCH_ORDER  = 2 ;   % position of test signal (0=random, 1=first, 2=second)
M.MAXREVERSAL  = 10;   % number of reversals required as stop criterion
M.FEEDBACK     = 1 ;   % flag for provision of feedback about correctness of answer

% ------------------------------ 
M.FS               = 48000; % sampling frequency
M.CALIB            = 100;   % means: a full-scale square wave has THIS dB SPL
M.USE_GUI          = 1;
M.INFO             = 1;     % flag for additional info for test subject
M.VISUAL_INDICATOR = 1;     % flag whether to use visual interval indication
M.DEBUG            = 0;

% ========================================
M.USE_MSOUND       = 1;     % flag whether to use msound (1 or 0)
M.MSOUND_DEVID     = 0;     % device ID for msound (choose 0 or [] for default device)
M.MSOUND_FRAMELEN  = 1024;  % framelen for msound (number of samples)
M.MSOUND_NCHAN     = 2;     % number of channels, must match  size(m_outsig,2)

% set sound card to maximum output
% system('volumemax&');

fprintf('\n\n\n');  %%clc;  
type match_freq_binaural_instruction.txt

M.SNAME = input('\n\n please type your name (initials, no spaces, press RETURN at end) ','s');


% ==================================================

%ref_freqs = 1000;
ref_freqs = [500 1000 2000 3000 6000];
% 
for freq = ref_freqs,
  
  M.PARAM(1) = freq;
  M.PARAM(2)  =  1;   % test signal side left
  
  % NOTE:  the content of ADAPT_METHOD will be saved in the psylab file ...
  M.ADAPT_METHOD = '1up_2down';
  % BUT:  during later analysis, display_psydat will not distinguish between
  %       different values of ADAPT_METHOD 
  % SOLUTION: save the information in a separate parameter
  M.PARAM(3) = 70.7;
  
  mpsy_match_main;

  
  % NOTE:  the content of ADAPT_METHOD will be saved in the psylab file ...
  M.ADAPT_METHOD = '2up_1down';
  % BUT:  during later analysis, display_psydat will not distinguish between
  %       different values of ADAPT_METHOD 
  % SOLUTION: save the information in a separate parameter
  M.PARAM(3) = 29.3;
  
  mpsy_match_main;
  
  
end



% End of file:  match_freq_binaural_singletrack.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
