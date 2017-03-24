% Usage: mpsy_match_main
% ----------------------------------------------------------------------
%          This is the main script of psylab for matching experiments.
%          It loops for a number of trials belonging to one
%          experimental run.  
%          Test stimulus and reference stimulus are presented
%          either randomly, or alway test first or always reference
%          first. The subject answer is recorded and used to
%          control a 1_up_1_down algorithm until threshold
%          (determined by a certain number of reversals) is
%          reached.  This script should be called from the main
%          experiment-script after all revelant psylab-variables
%          have been set. 
% 
%   input args:  (none) works on set of global variables M.* and
%                uses fixed signalname convention
%  output args:  (none) generates outputsignal, processes
%                subjects' answer and protocolls everything
%
% Copyright (C) 2003-2006   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  24 Oct 2006
% Updated:  <19 Mar 2009 08:38, martin>
% Updated:  < 1 Nov 2006 21:31, hansen>


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
  % we get HERE in case the user requested a quit of the experiment
  % at the beginning of a new run which isn't the very last of all runs.
  mpsy_info(M.USE_GUI, afc_fb, '*** user-quit of this experiment ***', afc_info, '');
  %disp('experiment was quit by user-request')
  return
end

% $$$ %% Check definition of adaptive rule for matching experiment.  If
% $$$ %% not present, issue a warning and set it to default value 1up_1down
% $$$ if ~isfield(M, 'ADAPT_METHOD'),
% $$$     fprintf('\n *** no adaptive method has been defined.\n')
% $$$     warning('setting adaptive method to default value ''1up_1down'' ');
% $$$     M.ADAPT_METHOD = '1up_1down';
% $$$ end

% clear previous run history, if any; set missing default values;
% open msound, if requested; 
mpsy_init_run;

if M.VISUAL_INDICATOR,
  M.VISUAL_INDICATOR = 0;
  disp('*** info:  The VISUAL_INDICATOR feature is not yet supported for matching experiments, ')
  disp('*** info:  as it does not make sense in most cases.');
end

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
    stmp = [stmp sprintf(',\n       Par.%d (%s): %g %s', ...
                         k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)))];
  end
	    
  mpsy_info(M.USE_GUI, afc_info, stmp);
end

M.UD = mpsy_query_user(M.USE_GUI, afc_fb, 'are you ready for this run?    to continue, hit RET');
% check user answer for a possible quit-request
if M.UD == 9, M.QUIT = 1;  end
if M.UD >= 8, return;  end
pause(0.5);




% ------------------------------------------------
% ----- start the loop of trials for one run -----
% ------------------------------------------------
while (M.REVERSAL < M.MAXREVERSAL) | (M.STEP > M.MINSTEP)

  % NEW REVERSED ORDER of step 1 and 2 rel. to version 2.2:
  % new values for M.VAR and M.STEP have been calculated based on
  % the adaptive rule in use.  
  % new step 1 (was: step 2)
  % generate new signals by use of the "user-script"
  eval([M.EXPNAME 'user']);
  
  % new step 2 (was: step 1)  
  % this is to reflect possible changes of M.VAR by the user
  % script.  For example, the user script might limit M.VAR to
  % within certain boundaries, e.g., to prevent amplitude clipping,
  % overmodulation, negative increments, etc.  
  % save current VAR and STEP 
  M.VARS  = [M.VARS M.VAR];
  M.STEPS = [M.STEPS M.STEP];
  
  
  % mount and present intervals in matching experiment fashion.
  % obtain and process user answer. 
  mpsy_match_present;
  % check user answer for a possible quit-request
  if M.UD>=8, return; end
  
  if M.FEEDBACK,
    mpsy_info(M.USE_GUI, afc_fb, feedback);
    pause(1);
  end

  % append the current answer to the array of all answers
  M.ANSWERS = [M.ANSWERS M.ACT_ANSWER];

  % now apply adaptive N-up M-down rule:
  % it adapts stimulus variable M.VAR, recalculates step size M.STEP, etc.
  eval( ['mpsy_adapt_' M.ADAPT_METHOD] )
  
  % check whether familiarization phase has ended and data
  % collection starts during measurement phase: 
  % note: a new M.STEP and M.VAR have just been calculated from the last answer
  if M.STEP == M.MINSTEP & M.STEPS(end) ~= M.MINSTEP,
    % count reversals during measurement phase again starting from 0
    M.REVERSAL = 0;
    if M.FEEDBACK, 
      mpsy_info(M.USE_GUI, afc_fb, 'starting measurement phase');
      pause(1)
    end
  end
  
  if M.DEBUG>1,
      htmp = gcf;    % remember current figure
      % show last stimuli and answers
      figure(111);   mpsy_plot_feedback;
      if M.DEBUG > 2,
	figure(112);   plot((1:length(m_outsig))/M.FS, m_outsig);
	title('stimuli of PREVIOUS run')
	xlabel('time [s]'); ylabel('amplitude');
      end
      if M.USE_GUI,
	figure(htmp);  % make previous figure current again, e.g. the answer GUI
      end
  end

end   % while REVERSAL loop
% ---------------------------------------------
% ----- end of loop of trials for one run -----
% ---------------------------------------------



%% save the new VAR and STEP which WOULD have been used next
M.VARS  = [M.VARS M.VAR];
M.STEPS = [M.STEPS M.STEP];

% protocol everything
mpsy_proto_adapt;
 
if M.FEEDBACK,  figure(111); mpsy_plot_feedback; end

mpsy_info(M.USE_GUI, afc_fb, '*** run completed ***');
pause(3);

if M.USE_MSOUND,
  msound('close');
end



% End of file:  mpsy_match_main.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
