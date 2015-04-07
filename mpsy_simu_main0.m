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
% Copyright (C) 2003-2006   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  24 Jun 2003
% Updated:  <25 Okt 2006 21:31, hansen>
% Updated:  <31 Mrz 2005 17:01, hansen>
% Updated:  <14 Jan 2004 11:30, hansen>


%% This file is not official part of PSYLAB 
%% and it is *not* GNU GPL copyrighted!


if M.MODE == M_SIMULATION & M.USE_GUI ==1,
  M.USE_GUI = 0;
  disp('setting M.USE_GUI = 0');
end

if M.QUIT,
  disp('experiment was quit by user-request')
  return
end

% clear previous run history, if any
mpsy_init_run;

% run the "set-script" once.  this should set some variables and/or signals
% to constant values or to start values:
eval([M.EXPNAME 'set']);

% check a number of variables for correct content/type, 
% also check for pre/post/quiet signals
mpsy_check;


switch M.MODE
 case M_LISTENER,
  if M.USE_GUI,
    set(afc_fb, 'String', 'are you ready for this run?    to continue, hit RET');
    ua = -1;  
    % the variable 'ua' gets set via KeyPressFcn of the GUI
    % note: exit from the following while loop also happens in case ua==[]
    while ua < 0,    pause (0.5);  end;   
  else
    input('\n\n are you ready for this run?    to continue, hit RET');
  end
  
 case M_SIMULATION,
  disp('starting simulation');
  
 otherwise
  error('undefined value of M.MODE');
end

if M.INFO,
  stmp = sprintf('this run: Parameter (%s): %g %s', ...
		 char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
  for k=2:M.NUM_PARAMS,
    stmp = [stmp sprintf(', Par.%d (%s): %g %s', k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)))];
  end
	    
  mpsy_info(M.USE_GUI, afc_info, stmp);
  if M.MODE == M_LISTENER,
    pause(2);
  end
end



% ------------------------------------------------
% ----- start the loop of trials for one run -----
% ------------------------------------------------
while (M.REVERSAL < M.MAXREVERSAL) | (M.STEP > M.MINSTEP)

  if exist('m_pausedur'),
    pause(m_pausedur);
  end
  
  % save current VAR and STEP 
  M.VARS  = [M.VARS M.VAR];
  M.STEPS = [M.STEPS M.STEP];
  
  % generate new signals by use of the "user-script"
  eval([M.EXPNAME 'user']);

  if length(M.VARS) == 1 & M.MODE == M_SIMULATION,
    % save the first supra-threshold test stimulus
    m_supra    = m_test;  
    rep_supra  = mpsy_internal_repr(m_supra, M.F0, M.FS); 
    rep_supra  = rep_supra + M.SIGMA*randn(size(rep_supra));
    
    rep_ref0   = mpsy_internal_repr(m_ref,   M.F0, M.FS); 
    rep_ref0   = rep_ref0 + M.SIGMA*randn(size(rep_ref0));
    % normalized difference of representations
    m_template = rep_supra - rep_ref0;
    m_template = m_template/rms(m_template);
  end
  
  switch M.MODE
   case M_LISTENER,   % ---------- listen ------------------------------------
    % mount signals in a random N-AFC fashion with the test signal being
    % situated in the interval numbered M.rand_afc
    %%% [m_outsig, rand_afc] = mpsy_nafc(m_test, m_ref, M.NAFC, m_quiet, m_presig, m_postsig);
    mpsy_nafc;
  
  
    % ... check for clipping
    if max(m_outsig) > 1 | min(m_outsig) < -1,
      mpsy_info(M.USE_GUI, afc_fb, '*** WARNING:  overload/clipping of m_outsig***')
      pause(2);
    end
    
    % check ear side, add silence on other side if necessary
    if ( (M.EARSIDE~=M_BINAURAL) & (min(size(m_outsig)) == 1) ), 
      if M.EARSIDE == M_LEFTSIDE,
	m_outsig = [m_outsig 0*m_outsig];  % mute right side
      elseif M.EARSIDE == M_RIGHTSIDE,
	m_outsig = [0*m_outsig m_outsig];  % mute left side
      else 
	fprintf('\n\n*** ERROR, wrong value of M.EARSIDE.\n'); 
	fprintf('*** must be M_BINAURAL, M_LEFTSIDE or M_RIGHTSIDE\n');
	return
      end
    end
    
    % ... clear possible feedback message in GUI
    mpsy_info(M.USE_GUI, afc_fb, '', afc_info, '');
    
    % ... and present
    sound(m_outsig, M.FS); 
    
    if M.VISUAL_INDICATOR & M.USE_GUI,
      mpsy_visual_interval_indicator;  %  acts depending on global variables
    else
      %  'sound' works asynchronously, so: pause execution for as long as
      %  the signal duration
      pause(length(m_outsig)/M.FS);
    end
    
    
    % get user answer
    ua = -1;
    %while (ua < 0 | ua > M.NAFC) & ua ~= 9,  
    while  ~any( ua == [ (0:M.NAFC) 8 9]),
      if M.USE_GUI,   %% ----- user answers via mouse/GUI
        set(afc_info, 'String', M.TASK);
	% a pause allows GUI-callbacks to be fetched
	pause(0.5);  
	if isempty(ua),  ua = -1;  end;
      else
	% prompt user for an answer via keyboard
	ua = input(M.TASK);
	if isempty(ua),  ua = -1;  end;
      end    
    end
    
    % ua contains user answer
    switch ua,
     case 9,         % user-quit request for this experiment
      mpsy_info(M.USE_GUI, afc_fb, '*** user-quit of this experiment ***', afc_info, '');
      M.QUIT = 1;   % set quit-flag, i.e. whole experiment is aborted completely
      pause(2);
      return;  %  abort this run, i.e. neither save anything
      
     case 8,         % user-quit request for this run
      mpsy_info(M.USE_GUI, afc_fb, '*** user-quit of this run ***', afc_info, '');
      pause(2);
      %  abort this run, i.e. neither save anything:
      return;   
      
     case 0,         % forced wrong answer, i.e. decrease stimulus variable
      M.ACT_ANSWER = 0;  % not correct
      feedback='*** FORCED not correct'; 
      
     case M.rand_afc,
      M.ACT_ANSWER = 1;  % correct
      feedback='correct';
      
     otherwise,
      M.ACT_ANSWER = 0;  % not correct
      feedback='NOT correct'; 
    end

    
   case M_SIMULATION,   % ---------- simu ------------------------------------

    rep_test = mpsy_internal_repr(m_test, M.F0, M.FS); 
    rep_test = rep_test + M.SIGMA*randn(size(rep_test));
    cc_test  = xcorr(rep_test-rep_ref0, m_template, 0, 'coeff');

    rep_ref  = mpsy_internal_repr(m_ref,  M.F0, M.FS); 
    
    if M.DEBUG>1,
      figure(120)
      subplot(4, 2, 1)
      plot(m_supra); title('m_supra')
      subplot(4, 2, 3)
      plot(m_test); title('m_test')
      subplot(4, 2, 5)
      plot(m_ref);  title('m_ref ohne int. noise')
      subplot(4, 2, 7)
      plot(m_template);  title('m_template')
      subplot(4, 2, 2)
      plot(rep_supra); title('rep_supra')
      subplot(4, 2, 4)
      plot(rep_test); title('rep_test')
      subplot(4, 2, 6)
      plot(rep_ref);  title('rep_ref')
      subplot(4, 2, 8)
      plot(rep_test-rep_ref0);  title(sprintf('rep_test-rep_ref0, cc=%g',cc_test));
      figure(122)
    end
    
    
    for k=1:M.NAFC-1,
      rep_refk = rep_ref + M.SIGMA*randn(size(rep_ref));
      cc_ref(k) = xcorr(rep_refk-rep_ref0, m_template, 0, 'coeff');
      if M.DEBUG>1,
	subplot(M.NAFC-1, 2, 2*k-1)
	plot(rep_refk); title('rep_refk')
	subplot(M.NAFC-1, 2, 2*k)
	plot(rep_refk-rep_ref0); title(sprintf('rep_refk-rep_ref0, cc=%g', cc_ref(k)));
	pause(0.01)
      end
    end
    
    
    if cc_test > max(cc_ref),
      M.ACT_ANSWER = 1;  % correct
      feedback='correct';
    else
      M.ACT_ANSWER = 0;  % not correct
      feedback='NOT correct'; 
    end
    
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

  % now apply adaptive N-up M-down rule, with already recalculated step size
  eval( ['mpsy_' num2str(M.ADAPT_N_UP) 'up_' num2str(M.ADAPT_N_DOWN) 'down;'] );
  
  
  % ----- check whether to start data collection: 
  % (notice: a new M.STEP and M.VAR have just been calculated from
  % the last answer) 
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
      if M.DEBUG > 1,
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
