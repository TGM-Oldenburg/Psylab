% Usage: mpsy_simu_main
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
% Copyright (C) 2007   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  18 Mar 2007
% Updated:  <27 Mai 2010 16:24, martin>
% Updated:  <20 Mar 2007 14:08, hansen>

%% This file is not official part of PSYLAB 
%% and it is *not* GNU GPL copyrighted!


if M.QUIT,
  disp('experiment was quit by user-request')
  return
end

% disable GUI for simulations, if not yet done. 
if M.MODE == M_SIMULATION & M.USE_GUI ==1,
  M.USE_GUI = 0;  disp('setting M.USE_GUI = 0');
end

% clear previous run history, if any
mpsy_init_run;

% run the "set-script" once.  this should set some variables and/or
% signals to constant values or to start values (among them are, at
% least, M.VAR and M.STEP)
eval([M.EXPNAME 'set']);

% check a number of variables for correct content/type, 
% also check for pre/post/quiet signals
mpsy_check;


if M.INFO,
  stmp = sprintf('\nthis run: Parameter (%s): %g %s', ...
		 char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
  for k=2:M.NUM_PARAMS,
    stmp = [stmp sprintf(', Par.%d (%s): %g %s', ...
                         k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)))];
  end
	    
  mpsy_info(M.USE_GUI, afc_info, stmp);
end

switch M.MODE
  case M_LISTENER,
    if M.USE_GUI,
      set(afc_fb, 'String', 'are you ready for this run?    to continue, hit RET');
      M.UA = [];  
      % the variable 'M.UA' gets set via KeyPressFcn of the GUI.
      % Actually, not only RET but also any key will lead to exit from
      % this while loop. The pause is essential for catching GUI events
      while isempty(M.UA),    pause (0.5);  end;   
    else
      M.UA = input('\n\n are you ready for this run?    to continue, hit RET');
    end
    % check user answer for a possible quit-request
    if M.UA == 9, M.QUIT = 1;  end
    if M.UA >= 8, return;  end
    pause(0.5);
  
  case M_SIMULATION,
    disp('*** starting simulation run ***');
  
  otherwise
    error('undefined value of M.MODE');
end




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
  

  switch M.MODE
   case M_LISTENER,    % ---------- listen ----------------------------------
    % mount and present intervals in n-AFC fashion.  
    % obtain and process user answer.
    mpsy_afc_present;
    % check user answer for a possible quit-request
    if M.UA>=8, return; end
    
   case M_SIMULATION,  % ---------- simu ------------------------------------
     mpsy_simulation;
    
   otherwise
    error('undefined value of M.MODE');
  end

  
  if M.FEEDBACK,
    mpsy_info(M.USE_GUI, afc_fb, feedback);
    if M.MODE == M_LISTENER,
      pause(1);
    end
    
  end

  % append the current answer to the array of all answers
  M.ANSWERS = [M.ANSWERS M.ACT_ANSWER];

  % now apply adaptive N-up M-down rule:
  % it adapts stimulus variable M.VAR, recalculates step size M.STEP, etc.
  eval( ['mpsy_adapt_' M.ADAPT_METHOD] )
  
  % check whether to start data collection: 
  % note: a new M.STEP and M.VAR have just been calculated from the last answer
  if M.STEP == M.MINSTEP & M.STEPS(end) > M.MINSTEP,
    % count reversals during measurement phase again starting from 0
    M.REVERSAL = 0;
    if M.FEEDBACK, 
      mpsy_info(M.USE_GUI, afc_fb, 'starting measurement phase');
      if M.MODE == M_LISTENER,
	pause(1)
      end
    end
  end
  
  if M.DEBUG,
      htmp = gcf;    % remember current figure
      % show last stimuli and answers
      figure(111);   mpsy_plot_feedback;
      if M.MODE == M_SIMULATION, pause(0.01); end
      if M.DEBUG > 1 & M.MODE == M_LISTENER
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
mpsy_proto;
 
if M.FEEDBACK,  figure(111); mpsy_plot_feedback; end

mpsy_info(M.USE_GUI, afc_fb, '*** run completed ***');
if M.MODE == M_LISTENER,
  pause(3);
end


% End of file:  mpsy_simu_main.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
