
% dies file ist nicht teil von psylab sondern dient nur zur entwicklung

%function y = check_messphase() 

%
% ----------------------------------------------------------------------
% Usage: y = check_messphase()
%
%   input:   ---------
%  output:   ---------
%
% Copyright (C) 2006 by Martin Hansen, Fachhochschule OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  27 Feb 2006
% Updated:  <>

%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

%if nargin < 1, help(mfilename); return; end;

l50 = -20;
m = 0.15;   %  Steigung in  %/dB

mpsy_init;
mpsy_init_run;


p_converge     = 0.707;  % 1up2down; 
p_converge     = 0.804;  % 1up3down; 
%p_converge     = 0.5;  % 1up1down; 
%p_converge     = 0.293;  % 2up1down; 

M.ADAPT_N_UP   = 1 ;  % number of succesive wrong answers required for "up"
M.ADAPT_N_DOWN = 3 ;  % number of succesive correct answer required for "down"



M.EXPNAME      = mfilename;
M.SNAME        = 'dullytester';
M.NUM_PARAMS   = 2;
M.PARAM(1)     = 999;
M.PARAM(2)     = -999;
M.PARAMNAME    = {'dullypar'};
M.PARAMUNIT    = {'Hz'};
M.PARAMNAME(2) = {'dullypar2'};
M.PARAMUNIT(2) = {'dB'};
M.VARNAME      = 'dullyvar';
M.VARUNIT      = 'dB';
M.TASK         = 'which interval contained the test signal (1,2,3)?  ';
M.MINSTEP      = 1 ;  % minumum step size, in units of M.VARUNIT
M.NAFC         = 3 ;  % number of forced choice intervals
M.MAXREVERSAL  = 8 ;  % number of reversals required as stop criterion
M.FEEDBACK     = 1 ;  % 1/0  = yes/no
M.INFO         = 1 ;


% ------------------------------ 
M.FS               = 48000; % sampling frequency
M.CALIB            = 100;   % means: a full-scale square wave has THIS dB SPL
M.EARSIDE          = M_BINAURAL;
%M.USE_GUI          = 1;     % use a GUI for user input
%M.VISUAL_INDICATOR = 1;     % use visual interval indication
M.DEBUG            = 0;



M.VAR    = 0;
M.STEP   = 8;




% ------------------------------------------------
% ----- start the loop of trials for one run -----
% ------------------------------------------------
while (M.REVERSAL < M.MAXREVERSAL) | (M.STEP > M.MINSTEP)

% $$$   if exist('m_pausedur'),
% $$$     pause(m_pausedur);
% $$$   end
  
  % save current VAR and STEP 
  M.VARS  = [M.VARS M.VAR];
  M.STEPS = [M.STEPS M.STEP];
  
% $$$   % generate new signals by use of the "user-script"
% $$$   eval([M.EXPNAME 'user']);
  
% $$$   % mount signals in a random N-AFC fashion with the test signal being
% $$$   % situated in the interval numbered rand_afc
% $$$   [m_outsig, rand_afc] = mpsy_nafc(m_test, m_ref, M.NAFC, m_quiet, m_presig, m_postsig);
  
% $$$   % ... check for clipping
% $$$   if max(m_outsig) > 1 | min(m_outsig) < -1,
% $$$     fprintf('***\n*** WARNING:  overload/clipping of m_outsig\n***\n');
% $$$   end

% $$$   % check ear side, add silence on other side if necessary
% $$$   if ( (M.EARSIDE~=M_BINAURAL) & (min(size(m_outsig)) == 1) ), 
% $$$     if M.EARSIDE == M_LEFTSIDE,
% $$$       m_outsig = [m_outsig 0*m_outsig];  % mute right side
% $$$     elseif M.EARSIDE == M_RIGHTSIDE,
% $$$       m_outsig = [0*m_outsig m_outsig];  % mute left side
% $$$     else 
% $$$       fprintf('\n\n*** ERROR, wrong value of M.EARSIDE.\n'); 
% $$$       fprintf('*** must be M_BINAURAL, M_LEFTSIDE or M_RIGHTSIDE\n');
% $$$       return
% $$$     end
% $$$   end
% $$$ 
% $$$   % ... clear possible feedback message in GUI
% $$$   if M.USE_GUI,    set(afc_fb, 'String', '');  end
% $$$ 
% $$$   % ... and present
% $$$   sound(m_outsig, M.FS); 
% $$$   
% $$$   if M.VISUAL_INDICATOR & M.USE_GUI,
% $$$     mpsy_visual_interval_indicator;  %  acts depending on global variables
% $$$   else
% $$$     %  'sound' works asynchronously, so: pause execution for as long as
% $$$     %  the signal duration
% $$$     pause(length(m_outsig)/M.FS);
% $$$   end
% $$$   
% $$$   % get user answer
% $$$   ua = -1;
% $$$   while (ua < 0 | ua > M.NAFC) & ua ~= 9,  
% $$$       if M.USE_GUI,   %% ----- user answers via mouse/GUI
% $$$ 	% a pause allows GUI-callbacks to be fetched
% $$$ 	pause(0.5);  
% $$$       else
% $$$ 	% prompt user for an answer via keyboard
% $$$ 	ua = input(M.TASK);
% $$$ 	if isempty(ua),  ua = -1;  end;
% $$$       end    
% $$$   end

% $$$   if ua == 9, % user-quit request
% $$$       if M.USE_GUI,
% $$$         set(afc_fb, 'String', '*** user-quit of this run ***');
% $$$       else
% $$$ 	fprintf('\n\n *** user-quit of this run \n\n');
% $$$       end
% $$$       pause(2);
% $$$       return;   %  abort this run completely
% $$$   end
  
% $$$   if ua == 0, % forced wrong answer, i.e. decrease stimulus variable
% $$$       M.ACT_ANSWER = 0;  % not correct
% $$$       feedback='*** FORCED not correct'; 
% $$$   elseif ua == rand_afc,
% $$$       M.ACT_ANSWER = 1;  % correct
% $$$       feedback='correct';
% $$$   else
% $$$       M.ACT_ANSWER = 0;  % not correct
% $$$       feedback='NOT correct'; 
% $$$   end


  % calculate correct answer via comparison of uniform randon
  % number with psychometric function at M.VAR
  M.ACT_ANSWER = ( 100*rand(1) < psyk_met_fkt1(M.VAR, l50, m) )   ;
  
  
  if M.ACT_ANSWER == 1, 
    feedback='correct';
  elseif M.ACT_ANSWER == 0;
    feedback='NOT correct';
  else
    error('error in calculation of M.ACT_ANSWER');
  end
  
  if M.FEEDBACK>1,
      if M.USE_GUI,
        set(afc_fb, 'String', feedback);
        pause(1);
      else
	fprintf('%s \n\n', feedback);
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
    messphase_trial = length(M.VARS)
    if M.FEEDBACK, 
      if M.USE_GUI,
	set(afc_fb, 'String', 'starting measurement phase');
      end
      disp(' starting measurement phase'); 
    end
    pause(1)
  end
  
  if M.DEBUG,
% $$$       htmp = gcf;    % remember current figure
      % show last stimuli and answers
      mpsy_plot_feedback;
% $$$       figure(112);   plot((1:length(m_outsig))/M.FS, m_outsig);
% $$$       if M.USE_GUI,
% $$$ 	figure(htmp);  % make previous figure current again, e.g. the answer GUI
% $$$       end
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



%% ------------------------------------------------------------

figure(111)
mpsy_plot_feedback;
hold on;
plot(M.REV_IDX, M.VARS(M.REV_IDX), 'kp');
legend('M\_VAR', 'correct', 'wrong', 'reversal point')
hold off;


mpsy_debug;



figure(1);
xtmp = (min(M.VARS):0.1:max(M.VARS));
x_converge = l50-1/(4*m)*log((1-p_converge)/p_converge);
plot(xtmp, psyk_met_fkt1(xtmp, l50, m), 'b', l50, 50, 'go'); 
hold on;
plot(x_converge, 100*p_converge, 'rp'); 
grid on;
title(sprintf('l50=%.1f,  m=%.3f,  psi(x=%.2f) = %.2f', l50, m, x_converge, p_converge));

idx_correct = find(M.ANSWERS == 1);
idx_wrong = find(M.ANSWERS == 0);
x_range = (min(M.VARS):max(M.VARS));
h1=hist(M.VARS(idx_correct), x_range); 
plot(x_range, 100*h1/length(M.VARS), 'color', [1 1 0]);
h2=hist(M.VARS(idx_wrong), x_range); 
plot(x_range, 100*h2/length(M.VARS), 'color', [0 1 1]);
hold off;
legend('psyc-func', 'l50', 'x/p converge', 'hist-corrects', 'hist-wrongs', 0);



% End of file:  check_messphase.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
