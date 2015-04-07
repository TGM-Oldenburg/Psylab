% Usage: mpsy_intrlv_match_main
% ----------------------------------------------------------------------
%          This is the main script of psylab for AFC experiments
%          with interleaved tracks.  It loops for a number of
%          trials belonging to different experimental tracks, until
%          all track have reached threshold.
%
%          For each track, test stimulus and reference stimulus are
%          presented; either randomly, or alway test first or always
%          reference first.  The subjects answer is recorded and used
%          to control some adaptive x_up_y_down algorithm (default:
%          1_up_1_down) until threshold (determined by a certain
%          number of reversals) is reached.  This script should be
%          called from the main experiment-script after all revelant
%          psylab-variables have been set.
% 
%   input args:  (none) works on set of global variables M.* and
%                uses fixed signalname convention
%  output args:  (none) generates outputsignal, processes
%                subjects' answer and protocolls everything
%
% Copyright (C) 2012  Martin Hansen, Jade Hochschule
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  23 Nov 2012
% Updated:  < 8 Apr 2013 08:42, martin>
% Updated:  <23 Nov 2012 21:44, martin>


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


% initialization of interleaved tracks experiment. 
% clear previous runs' history, if any 
mpsy_intrlv_init;

for k=1:M1.NUM_INTERLEAVED_TRACKS,
  M = MI(k);
  % run the "set-script" once.  this should set some variables and/or
  % signals to constant values or to start values (among them are, at
  % least, M.VAR and M.STEP)
  eval([M.EXPNAME 'set']);
  % fill new values/fields of M back into MI(k)
  MI(k) = M;
end
  
% check a number of variables for correct content/type, also check for
% pre/post/quiet signals.  This check only needs to be performed once
% for all fields of MI(1), as MI(2:end) will contain the same type of
% information via previous call to mpsy_intrlv_init
M = MI(1);
mpsy_check;

if M.QUIT
  % we get HERE in case the user requested a quit of the experiment
  % at the beginning of a new run which isn't the very last of all runs.
  mpsy_info(M.USE_GUI, afc_fb, '*** user-quit of this experiment ***', afc_info, '');
  %disp('experiment was quit by user-request')
  return
end


if M.VISUAL_INDICATOR,
  M.VISUAL_INDICATOR = 0;
  disp('*** info:  The VISUAL_INDICATOR feature is not yet supported for matching experiments, ')
  disp('*** info:  as it does not make sense in most cases.');
end


% showing this info as in mpsy_afc_main does not make sense in an
% interleaved experiment, as it would only confuse the subject
% repeatedly 
% $$$ if M.INFO,
% $$$   stmp = sprintf('\nthis run: Parameter (%s): %g %s', ...
% $$$ 		 char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
% $$$   for k=2:M.NUM_PARAMS,
% $$$     stmp = [stmp sprintf(', Par.%d (%s): %g %s', ...
% $$$                          k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)))];
% $$$   end
% $$$ 	    
% $$$   mpsy_info(M.USE_GUI, afc_info, stmp);
% $$$ end

if M.USE_GUI,
  set(afc_fb, 'String', 'are you ready for this run?    to continue, hit RET');
  M.UD = -1;   
  % the variable 'M.UD' gets set via KeyPressFcn of the GUI.
  % Actually, not only RET but also any key will lead to exit from
  % this while loop. The pause is essential for catching GUI events
  while M.UD == -1,    pause (0.5);  end;   
  set(afc_fb, 'String', '');
else
    M.UD = input('\n\n are you ready for this run?    to continue, hit RET');
end
% check user answer for a possible quit-request
if M.UD == 9, M.QUIT = 1;  end
if M.UD >= 8, return;  end
pause(0.5);




% ------------------------------------------------
% ----- start the loop of trials for one run -----
% ------------------------------------------------
%while (M.REVERSAL < M.MAXREVERSAL) | (M.STEP > M.MINSTEP)
while ~all(M1.TRACKS_COMPLETED)

  % select one track, put its data into variable 'M'
  mpsy_intrlv_gettrack;
  
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
  if M.UD>=8, ,
    % mark THIS track as completed
    M1.TRACKS_COMPLETED(M1.cur_track_idx) = 1;
    if M.UD>=9,
      % mark ALL track as completed
      M1.TRACKS_COMPLETED(:) = 1;
      return; 
    end
  end
  
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
  if M.STEP == M.MINSTEP & M.STEPS(end) > M.MINSTEP,
    % count reversals during measurement phase again starting from 0
    M.REVERSAL = 0;
    
    % do not issue info about start of measurement phase for
    % interleaved tracks experiments! 
    %if M.FEEDBACK, 
    %  mpsy_info(M.USE_GUI, afc_fb, 'starting measurement phase');
    %  pause(1)
    %end
  end
  
  if M.DEBUG,
      htmp = gcf;    % remember current figure
      % show last stimuli and answers
      figure(120+M1.cur_track_idx);   mpsy_plot_feedback;
      if M.DEBUG > 1,
	figure(130+M1.cur_track_idx);   plot((1:length(m_outsig))/M.FS, m_outsig);
	title('stimuli of PREVIOUS run')
	xlabel('time [s]'); ylabel('amplitude');
      end
      if M.USE_GUI,
	figure(htmp);  % make previous figure current again, e.g. the answer GUI
      end
  end
  
  
  if (M.REVERSAL >= M.MAXREVERSAL) & (M.STEP <= M.MINSTEP),
    % threshold of THIS track has just been reached, so ...
    % ... mark this event by setting  
    M1.TRACKS_COMPLETED(M1.cur_track_idx) = 1;
    
    %% save the new VAR and STEP which WOULD have been used next
    M.VARS  = [M.VARS M.VAR];
    M.STEPS = [M.STEPS M.STEP];
    % protocol everything of this track
    mpsy_proto;
  end
  
  % fill data of current track, stored in M, back into array MI of all tracks 
  mpsy_intrlv_puttrack;

end   % while not all tracks completed loop
% -----------------------------------------------
% -----   end of loop of trials and runs    -----
% -----------------------------------------------

 
if M.FEEDBACK,  
  for k=1:M1.NUM_INTERLEAVED_TRACKS,
    M = MI(k);
    figure(120+k);    mpsy_plot_feedback;
  end
end

mpsy_info(M.USE_GUI, afc_fb, '*** run(s) completed ***');
pause(3);

if M.USE_MSOUND,
  msound('close');
end



% End of file:  mpsy_intrlv_match_main.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
