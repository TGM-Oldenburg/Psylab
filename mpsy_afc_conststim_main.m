% Usage: mpsy_afc_conststim_main
% ----------------------------------------------------------------------
%          This is the main script of psylab for AFC experiments
%          with the constant stimulus method.  
%          It loops for a specified number of trials, also called a
%          block, belonging to one experimental run.  
%          In the loop, test stimulus and reference stimulus/stimuli are
%          presented in an N-AFC manner and the subjects answer is
%          recorded.  After the specified number of constant stimulus
%          presentations has been presented, the percentage of correct
%          answers is calculated and saved.
%          This script should be called from the main experiment-script
%          after all revelant psylab-variables have been set.
% 
%   input args:  (none) works on set of global variables M.* and
%                uses fixed signalname convention
%  output args:  (none) generates outputsignal, processes
%                subjects' answer and protocolls everything
%
% Copyright (C) 2016   Martin Hansen, Jade Hochschule
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  20 Okt 2016
% Updated:  <21 Okt 2016 15:16, martin>


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
  % we would get HERE in case the user requested a quit of the experiment
  % at the beginning of a new run which isn't the very last of all runs.
  mpsy_info(M.USE_GUI, afc_fb, '*** user-quit of this experiment ***', afc_info, '');
  %disp('experiment was quit by user-request')
  return
end

% clear previous run history, if any; set missing default values;
% open msound, if requested; 
mpsy_init_run;

% run the "set-script" once.  this should set some variables and/or
% signals to constant values or to start values (among them is, at
% least, M.VAR)
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

M.UA = mpsy_query_user(M.USE_GUI, afc_fb, 'are you ready for this run?    to continue, hit RET');
% check user answer for a possible quit-request
if M.UA == 9, M.QUIT = 1;  end
if M.UA >= 8, return;  end
pause(0.5);



% Set up matrix with all values for M.VAR in each row, and 1 row per
% repetition.  As an example, for M.VAR values [4, 6, 7, 8] and 3 (repeated) 
% presentations this will look like:  
% M.CONSTSTIM_ALLTRIALS = [4 6 7 8 
%                          4 6 7 8 
%                          4 6 7 8]
%
M.CONSTSTIM_ALLTRIALS = ones(M.CONSTSTIM_NUM_PRESENTATIONS, 1) * M.CONSTSTIM_ALLVARS(:)';

% Set up matrix for all subject answers, where answer = 0 means: "wrong",
% answer = 1 means: "correct".  Initialize with values -1 to indicate
% that the stimulus has not yet been presented/answered.
M.CONSTSTIM_ALLANSWERS = zeros(size(M.CONSTSTIM_ALLTRIALS))  -1 ;

% calculate number of trials in the block 
M.CONSTSTIM_NTRIALS = prod(size(M.CONSTSTIM_ALLTRIALS));

% generate a random pertubation of all constant stimuli in the block
M.RAND_ORDER = randperm(M.CONSTSTIM_NTRIALS);

% --------------------------------------------------
% ----- start the loop of trials for one block -----
% --------------------------------------------------
for M_TRIAL_COUNT = 1 : M.CONSTSTIM_NTRIALS,

  % Choose the next value for M.VAR in random order from all constant stimuli
  % belonging to the experiment block.  Note, the 1-dim index M.TRIAL_COUNT
  % into the 2-dim matrix is used here.
  M.VAR = M.CONSTSTIM_ALLTRIALS(M.RAND_ORDER(M_TRIAL_COUNT));
   
  % Generate new signals by use of the "user-script"
  eval([M.EXPNAME 'user']);

  % Mount intervals in n-AFC fashion, present them, 
  % obtain and process user answer.
  mpsy_afc_present;
  % check user answer for a possible quit-request
  if M.UA>=8, return; end
  
  if M.FEEDBACK,
    mpsy_info(M.USE_GUI, afc_fb, feedback);
    pause(1);
  end

  % insert the current answer into the matrix of all answers, again using
  % a 1-dim index into the 2-dim matrix.
  M.CONSTSTIM_ALLANSWERS(M.RAND_ORDER(M_TRIAL_COUNT)) = M.ACT_ANSWER;

  if M.DEBUG>1,
      htmp = gcf;    % remember current figure (typically the GUI)
      figure(110);   
      plot_tmp_vars = M.CONSTSTIM_ALLTRIALS(M.RAND_ORDER(1:M_TRIAL_COUNT));
      plot_tmp_answ = M.CONSTSTIM_ALLANSWERS(M.RAND_ORDER(1:M_TRIAL_COUNT)); 
      idx_plus = find(plot_tmp_answ ==1);
      idx_minus = find(plot_tmp_answ ==0);
      hp = plot(1:length(plot_tmp_vars), plot_tmp_vars, '.-', ...
                idx_plus, plot_tmp_vars(idx_plus), 'r+', ...
                idx_minus, plot_tmp_vars(idx_minus), 'ro');
      set(hp(1) , 'Color', 0.5*[1 1 1])
      xlabel('trial number')
      yl = [ M.VARNAME ' [' M.VARUNIT ']'];
      ylabel(strrep(yl, '_','\_'));
      tit = ['Exp.: ' M.EXPNAME ', Parameter: ' char(M.PARAMNAME(1)) ' = ' num2str(M.PARAM(1)) ' ' char(M.PARAMUNIT(1))];
      
      for k=2:M.NUM_PARAMS,
        tit = [tit '  Par.' num2str(k) ': ' char(M.PARAMNAME(k)) ' = ' num2str(M.PARAM(k)) ' ' char(M.PARAMUNIT(k))];
      end
      title(strrep(tit,'_','\_'));

      if M.DEBUG > 2,
        % show progress of averall measurement 
        figure(111);   
        mesh(M.CONSTSTIM_ALLVARS, 1:M.CONSTSTIM_NUM_PRESENTATIONS, M.CONSTSTIM_ALLANSWERS);
        xlabel(strrep(sprintf('variable:   %s (%s)', M.VARNAME, M.VARUNIT), '_', '\_'));
        ylabel('# presentation')
        zlabel('subject answer (0=wrong, 1=correct)')
        title('intermediate answers')
        
        % show last stimuli 
	figure(112);   plot((1:length(m_outsig))/M.FS, m_outsig);
	title('stimuli of PREVIOUS run')
	xlabel('time [s]'); ylabel('amplitude');
      end
      if M.USE_GUI,
	figure(htmp);  % make previous figure current again, e.g. the answer GUI
      end
  end

end   % for loop 
% ---------------------------------------------
% ----- end of loop of trials for one block ---
% ---------------------------------------------

if any(M.CONSTSTIM_ALLANSWERS<0),
  error(' Experimental block was not completed.  Data are NOT automatically saved by mpsy_proto_conststim.');
end


% protocol everything
mpsy_proto_conststim;
 
if M.FEEDBACK,  
  % figure(111); mpsy_plot_feedback; 
  fprintf('*** info: a plot of the results can be generated via display_psydat\n')
end

mpsy_info(M.USE_GUI, afc_fb, '*** run completed ***');
pause(3);

if M.USE_MSOUND,
  msound('close');
end



% End of file:  mpsy_afc_conststim_main.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
