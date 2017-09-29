% Measurement of level detection threshold for a sinusoidal tone in broad band noise
%
% Usage: tone_in_broadbandnoise
%
% Copyright (C) 2007       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  14 Jun 2007
% Updated:  <14 Jun 2007 12:22, hansen>

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
M.PARAMNAME(1) = {'testtone_frequency'};
M.PARAMUNIT(1) = {'Hz'};
M.PARAMNAME(2) = {'noise_level'};
M.PARAMUNIT(2) = {'dB'};
M.VARNAME      = 'testtone_level';
M.VARUNIT      = 'dB';
M.TASK         = 'which interval contained the test signal (1,2,3)?  ';
M.MINSTEP      = 1 ;  % minumum step size, in units of M.VARUNIT
M.NAFC         = 3 ;  % number of forced choice intervals
M.ADAPT_METHOD = '1up_2down'; 
M.MAXREVERSAL  = 8 ;  % number of reversals required as stop criterion
M.FEEDBACK     = 1 ;  % flag for provision of feedback about correctness of answer
M.INFO         = 1 ;  % flag for additional info for test subject


% ------------------------------ 
M.FS               = 48000; % sampling frequency
M.CALIB            = 100;   % means: a full-scale square wave has THIS dB SPL
M.EARSIDE          = M_BINAURAL;
M.USE_GUI          = 1;     % use a GUI for user input
M.VISUAL_INDICATOR = 1;     % flag whether to use visual interval indication
M.DEBUG            = 0;

% ------------------------------
M.USE_MSOUND       = 0;     % flag whether to use msound (1 or 0)
M.MSOUND_DEVID     = 0;     % device ID for msound (choose 0 or [] for default device)
M.MSOUND_FRAMELEN  = 1024;  % framelen for msound (number of samples)
M.MSOUND_NCHAN     = 1;     % number of channels, must match  size(m_outsig,2)

% set sound card to maximum output to ensure a permanent calibration
% system('volumemax&');

fprintf('\n\n\n\n');  %%clc;  
type tone_in_noise_instruction.txt

M.SNAME = input('\n\n please type your name (initials, no spaces, press RETURN at end) ','s');


% ==================================================

% interleave some tracks with different tone frequencies:
tone_freqs = [ 200 400 800 1600 3200 6400 ]; 
for kk = 1:length(tone_freqs),
    M(kk).PARAM(1) = tone_freqs(kk);
    M(kk).PARAM(2) = -30;
end

mpsy_intrlv_afc_main;
mpsy_plot_thresholds;
display_psydat(M.SNAME, M.EXPNAME)




% End of file:  tone_in_broadbandnoise.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
