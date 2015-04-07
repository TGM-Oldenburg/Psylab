% Measurement of frequency-JND for Sinusoids as a function of Frequency
%
% Usage: jnd_frequency
%
% Copyright (C) 2003       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  26 Jun 2005
% Updated:  <26 Jun 2005 18:00, mh>

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
M.NUM_PARAMS   = 2;            % number of parameters
M.PARAMNAME(1) = {'reference_frequency'};
M.PARAMUNIT(1) = {'Hz'};
M.PARAMNAME(2) = {'tone_level'};
M.PARAMUNIT(2) = {'dB'};
M.VARNAME      = 'rel_frequency_increment';
M.VARUNIT      = 'cent';
M.TASK         = 'which interval contained the test signal (1,2,3)?  ';
M.MINSTEP      = 1 ;   % minumum step size, in units of M.VARUNIT
M.NAFC         = 3 ;   % number of forced choice intervals
M.ADAPT_METHOD = '1up_2down'; 
M.MAXREVERSAL  = 8 ;   % number of reversals required as stop criterion
%% M.REVERSAL     = 3;   % force start of measurement phase according to M.STEP only
M.FEEDBACK     = 1 ;     % flag for provision of feedback about correctness of answer

% ------------------------------ 
M.FS               = 48000; % sampling frequency
M.CALIB            = 100;   % means: a full-scale square wave has THIS dB SPL
M.USE_GUI          = 1;
M.VISUAL_INDICATOR = 1;     % flag whether to use visual interval indication
M.DEBUG            = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M.USE_MSOUND       = 1;     % flag whether to use msound (1 or 0)
M.MSOUND_DEVID     = 0;     % device ID for msound (choose 0 or [] for default device)
M.MSOUND_FRAMELEN  = 1024;  % framelen for msound (number of samples)
M.MSOUND_NCHAN     = 1;     % number of channels, must match  size(m_outsig,2)

%M.EARSIDE = M_BINAURAL;

% set sound card to maximum output
% dos('volumemax&');

clc;  
type jnd_frequency_instruction.txt

M.SNAME = input('\n\n please type your name (initials, no spaces, press RETURN at end) ','s');

%% ==================================================
M.PARAM(2)  =  -30;

ref_freqs = 1000;
%ref_freqs = [250 500 1000 2000 3000 6000];
% 
for freq = ref_freqs,
   
  M.PARAM(1) = freq;
  mpsy_afc_main;
  mpsy_plot_result;
 
end



% %% ==================================================
% M.PARAM(2)  = -15;
% 
% for freq = ref_freqs,
%    
%   M.PARAM(1) = freq;
%   mpsy_afc_main;
%   mpsy_plot_result;
%  
% end




% End of file:  jnd_frequency.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
