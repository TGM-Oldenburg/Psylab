% Usage: mpsy_FixPrcdr_afc_main
% ----------------------------------------------------------------------
%          This is the main script of psylab for AFC experiments.
%          It loops for a number of trials belonging to one
%          experimental run.  
%          Test stimulus and reference stimulus are presented in an N
%          AFC manner and the subject answer is recorded to control a
%          x_up_y_down algorithm until threshold (determined by a
%          certain number of reversals) is reached.  This script
%          should be called from the main experiment-script after all
%          revelant psylab-variables have been set.
% 
%   input args:  (none) works on set of global variables M.* and
%                uses fixed signalname convention
%  output args:  (none) generates outputsignal, processes
%                subjects' answer and protocolls everything
%
% This file is based on the existing mpsy_afc_main.m by Martin Hansen
% and was modified by Georg Stiefenhofer.  
%
% The aim is to implement fixed procedures, i.e. no adaptive tracking
% is used, but fixed instances are presented to the subject and
% several points on the psychometric functions are estimated.
%
% Author :  Georg Stiefenhofer
% Date   :  November 2007



%% This file is part of PSYLAB, a collection of scripts for
%% designing and controlling interactive psychoacoustical listening
%% experiments.  
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.  See the GNU General
%% Public License for more details:  http://www.gnu.org/licenses/gpl
%% This file is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


if M.QUIT,
  disp('experiment was quit by user-request')
  return
end

% clear previous run history, if any
mpsy_init_run;

% if M.FIX_PROCDR
    % create vector containing the stimulus variable for all trials and
    % randomize it, if desired.
    M.VARS = repmat(M.FIX_ALLVARS, [M.FIX_TRIALS , 1] );
    M.VARS = M.VARS(:);
    if M.FIX_RANDVARS
        M.FIX_ORDOFPRSNT = randperm(length(M.VARS));
        M.VARS = M.VARS(M.FIX_ORDOFPRSNT);
    end
    fixPrcd_TrialCounter = 1;
    fixPrcd_NumberTrials = length(M.VARS);
    M.VAR = M.VARS(1);

    % NOTE: this is just a workaround. In mpsy_check.m M.STEP must NOT be
    % empty. But it's not used in a fixed procedure, so set to 0.
    M.STEP = 0;

% run the "set-script" once.  this should set some variables and/or
% signals to constant values or to start values (among them are, at
% least, M.VAR and M.STEP)
eval([M.EXPNAME 'set']);

% check a number of variables for correct content/type, 
% also check for pre/post/quiet signals
mpsy_check;


if M.INFO,
  stmp = sprintf('this run: Parameter (%s): %g %s', ...
		 char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
  for k=2:M.NUM_PARAMS,
    stmp = [stmp sprintf(', Par.%d (%s): %g %s', k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)))];
  end
	    
  mpsy_info(M.USE_GUI, afc_info, stmp);
end

if M.USE_GUI,
  set(afc_fb, 'String', 'are you ready for this run?    to continue, hit RET');
  M.UA = -1;  
  % the variable 'M.UA' gets set via KeyPressFcn of the GUI
  % note: exit from the following while loop also happens in case M.UA==[]
  while M.UA < 0,    pause (0.5);  end;   
else
    input('\n\n are you ready for this run?    to continue, hit RET');
end
% check user answer and for a possible quit-request
if M.UA >=8,  return;  end
pause(0.5);




% ------------------------------------------------
% ----- start the loop of trials for one run -----
% ------------------------------------------------
while fixPrcd_TrialCounter <= fixPrcd_NumberTrials
    M.VAR = M.VARS(fixPrcd_TrialCounter); 

  % generate new signals by use of the "user-script"
  eval([M.EXPNAME 'user']);
  
  % mount and present intervals in n-AFC fashion.  obtain and process user answer.
  mpsy_present;
  % check user answer and for a possible quit-request
  if M.UA>=8, return; end
  
  if M.FEEDBACK,
    mpsy_info(M.USE_GUI, afc_fb, feedback);
    pause(.5);
  end

  % append the current answer to the array of all answers
  M.ANSWERS = [M.ANSWERS M.ACT_ANSWER];

  if M.DEBUG,
      htmp = gcf;    % remember current figure
      % show last stimuli and answers
      figure(111);   mpsy_plot_feedback;
      if M.DEBUG > 1,
	figure(112);   plot((1:length(m_outsig))/M.FS, m_outsig);
	title('stimuli of PREVIOUS run')
	xlabel('time [s]'); ylabel('amplitude');
      end
      if M.USE_GUI,
	figure(htmp);  % make previous figure current again, e.g. the answer GUI
      end
  end
    fixPrcd_TrialCounter = fixPrcd_TrialCounter + 1;
end   % while REVERSAL loop
% ---------------------------------------------
% ----- end of loop of trials for one run -----
% ---------------------------------------------

% protocol everything
% NOTE: mpsy_FixPrcdr_proto (based on mpsy_proto) is run several times in
% loop for each M.FIX_ALLVARS that serves now as temporary M.PARAM(1). 
% PSYLAB                           Psylab with fixed procedure
% Threshold of M.VAR        --->   percent correct
% fixed present. instances  --->   M.PARAM(1)
% Par1                      --->   Par(2)                    
tmp = M.VARS;
for kk = M.FIX_ALLVARS
    idx = find(tmp == kk);
    M.VARS = M.ANSWERS(idx) * 100;
    M.PARAM(1) = kk;
    mpsy_FixPrcdr_proto;
end
M.VARS = tmp; 
if M.FEEDBACK,  figure(111); mpsy_plot_feedback; end

mpsy_info(M.USE_GUI, afc_fb, '*** run completed ***');
pause(3);




