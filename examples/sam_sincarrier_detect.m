% Measurement of modulation detection threshold for SAM as a function of modulation frequency
%
% Usage: sam_sincarrrier_detect
%
% Copyright (C) 2005       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  3 Apr 2005
% Updated:  <24 Mar 2017 11:14, mh>
% Updated:  <15 Apr 2016 14:38, mh>
% Updated:   <13 Mai 2005 15:51, mh>

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


% This experiment reproduces the experiment by
% Kohlrausch, Fassel, Dau (2000), JASA 108(2), p. 723-734,
% who investigated the detection threshold of the modulation degree
% for sinusoidal amplitude modulation of a sinusoidal carrier.



mpsy_init;

% ------------------------------ set M.* variables
M.EXPNAME      = mfilename;    % experiment name, very important to be set correctly!
M.NUM_PARAMS   = 2;            % number of parameters
M.PARAMNAME(1) = {'modulation_frequency'};
M.PARAMUNIT(1) = {'Hz'};
M.PARAMNAME(2) = {'carrier_frequency'};   % choose value -1 for broad band carrier
M.PARAMUNIT(2) = {'Hz'};
M.VARNAME      = 'modulation_degree';
M.VARUNIT      = 'dB';
M.TASK         = 'which interval contained the test signal (1,2,3)?  ';
M.MINSTEP      = 1 ;  % minumum step size, in units of M.VARUNIT
M.NAFC         = 3 ;  % number of forced choice intervals
M.ADAPT_METHOD = '1up_2down';   % transformed 1-up-2-down
% %%M.ADAPT_METHOD = '2up_1down';   % transformed 2-up-1-down
% %%M.PC_CONVERGE  = 0.75;
% %%M.ADAPT_METHOD = 'uwud';   % unforced weighted up down
M.MAXREVERSAL  = 8 ;  % number of reversals required as stop criterion

M.FEEDBACK     = 1 ;  % 1/0 = yes/no, 2=show result plot, 3=save it with individual name
M.INFO         = 1 ;  % flag to provide intermediate info for the subject


% ------------------------------ 
M.FS               = 48000; % sampling frequency
M.CALIB            = 100;   % means: a full-scale square wave has THIS dB SPL
M.EARSIDE          = M_BINAURAL;
M.USE_GUI          = 1;     % use a GUI for user input
M.VISUAL_INDICATOR = 1;     % flag whether to use visual interval indication
M.SAVERUN          = 1;     % save all values of M.VAR during run in psydat file
M.DEBUG            = 0;

% ----------------------------------------
M.USE_MSOUND       = 1;     % flag whether to use msound (1 or 0)
M.MSOUND_DEVID     = 0;     % device ID for msound (choose 0 or [] for default device)
M.MSOUND_FRAMELEN  = 1024;  % framelen for msound (number of samples)
M.MSOUND_NCHAN     = 1;     % number of channels, must match  size(m_outsig,2)


% set sound card to maximum output to ensure a permanent calibration
% system('volumemax&');

fprintf('\n\n\n'); 
type sam_instruction.txt

M.SNAME = input('\n\n please type your name (initials, no spaces, press RETURN at end) ','s');


% ========================================

% %%carrier_freqs = -1;  %  results in broad band noise
carrier_freqs = [ 800 1600 3200 ]; 

mod_freqs     = [ 16 64 256 ];

for carrierf = carrier_freqs,
    M.PARAM(2) = carrierf;
    for modf = mod_freqs,
        M.PARAM(1) = modf;
        mpsy_afc_main;
    end
end
mpsy_plot_thresholds;



% ==================================================
% M.PARAM(2)  =  1000;

% M.PARAM(1) = 2;
% mpsy_afc_main;
%
% M.PARAM(1) = 4;
% mpsy_afc_main;

% M.PARAM(1) = 8;
% mpsy_afc_main;

% M.PARAM(1) = 16;
% mpsy_afc_main;

% mpsy_plot_thresholds;



% ==================================================
% M.PARAM(2)  = 2000;

% M.PARAM(1) = 2;
% mpsy_afc_main;
%
% M.PARAM(1) = 4;
% mpsy_afc_main;

% M.PARAM(1) = 8;
% mpsy_afc_main;

% M.PARAM(1) = 16;
% mpsy_afc_main;

% mpsy_plot_thresholds;



% End of file:  sam_sincarrrier_detect.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
