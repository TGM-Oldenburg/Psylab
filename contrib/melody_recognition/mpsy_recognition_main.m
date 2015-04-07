% Usage: mpsy_recognition_main
% ----------------------------------------------------------------------
% This is the main script of psylab for recognition experiments.
% 
% input args:	(none) works on set of global variables M.* and
%               uses fixed signalname convention
% output args:	(none) generates outputsignal, processes
%               subjects' answer and protocolls everything
%
% Copyright (C) 2007   Anika Baugart, Sven Franz
% Author :  Anika Baugart <anika.baugart AT stud.fh-oldenburg.de>,
%           Sven Franz <sven.franz AT stud.fh-oldenburg.de>
% Date   :  13 Nov 2007
% Based on existing mpsy_*_main psylab-scripts by Martin Hansen

%% This file is an extension for PSYLAB, a collection of scripts for
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

% run the "set-script" once.  this should set some variables and/or
% signals to constant values or to start values
eval([M.EXPNAME 'set']);

% set some variables to default-values
M.VAR = 1;      % inherits the selected test-tone (will be set randomly later)
M.STEP = 1;     % variable ist only used in following psylab-files (see bottom of this file)
M.MINSTEP = 1;  % variable ist only used in following psylab-files (see bottom of this file)

% add 'NOT RECOGNIZED' to M.COMPRARE_NAMES, when M.COMPAREWITHNONE is set
if isfield(M, 'COMPAREWITHNONE') && M.COMPAREWITHNONE == 1
    M.COMPRARE_NAMES = [M.COMPRARE_NAMES(1:M.N_RECOGNITION) 'NOT RECOGNIZED'];
else
    M.COMPAREWITHNONE = 0;
end

% check M.LOOPS for correct content/type, 
if ~isfield(M, 'LOOPS') || M.LOOPS < 1
    M.LOOPS = 1;
end

% check a number of variables for correct content/type,
% also check for pre/post/quiet signals
mpsy_check;

% randomize test-stimuli (M.LOOPS-times)
M.RANDOMSTIMULI = randperm(M.N_RECOGNITION * M.LOOPS);

% check for length of stimuli-names
if M.N_RECOGNITION > length(M.COMPRARE_NAMES)
	error('psylab-variable "M.N_RECOGNITION" must less/equal length of "M.COMPRARE_NAMES"! ');
end
    
if M.INFO,
	stmp = sprintf('this run: Parameter (%s): %g %s\n', ...
		 char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
	for k=2:M.NUM_PARAMS,
        stmp = [stmp sprintf(', Par.%d (%s): %g %s', k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)))];
    end
	mpsy_info(M.USE_GUI, afc_info, stmp);
end

if M.USE_GUI,
	set(afc_fb, 'String', 'are you ready for this run?    to continue, hit RET');
	M.RE = -1;  
	% the variable 'M.RE' gets set via KeyPressFcn of the GUI
	% note: exit from the following while loop also happens in case M.RE==[]
	while M.RE < 0,    pause (0.5);  end;   
else
	input('\n\n are you ready for this run?    to continue, hit RET');
end
% check user answer and for a possible quit-request
if isfield(M, 'RE') && ischar(M.RE) && (strcmp(M.RE, 'r') || strcmp(M.RE, 'e'))
    return
end
pause(0.5);

% ------------------------------------------------
% ----- start the loop of trials for one run -----
% ------------------------------------------------

% while length of M.RANDOMSTIMULI >= 1
while ~isempty(M.RANDOMSTIMULI);
    % set the number of the next stimulus
    M.VAR = mod(M.RANDOMSTIMULI(1), M.N_RECOGNITION) + 1;
  
	% save current VAR and STEP 
	M.VARS  = [M.VARS M.VAR];
  
	% generate new signals by use of the "user-script"
	eval([M.EXPNAME 'user']);
  
	% add current stimuls, m_presig, m_postsig to current m_outsig
	[m_outsig, test_pos] = mpsy_match(m_test, [], 1, [], m_presig, m_postsig);
  
	% ... check for clipping
	if max(m_outsig) > 1 | min(m_outsig) < -1,
        mpsy_info(M.USE_GUI, afc_fb, '*** WARNING:  overload/clipping of m_outsig***')
        pause(2);
    end

	% check ear side, add silence on other side if necessary
	if ((M.EARSIDE~=M_BINAURAL) && (min(size(m_outsig)) == 1)), 
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
    % set background-color of gui to white if M.VISUAL_INDICATOR is set
	if M.VISUAL_INDICATOR && M.USE_GUI,
        tempcolor = get(psylab_gui, 'Color');
        set(psylab_gui, 'Color', [1 1 1]);
    end
	%  'sound' works asynchronously, so: pause execution for as long as
    %  the signal duration
    pause(length(m_outsig)/M.FS);
    % reset background-color of gui if M.VISUAL_INDICATOR is set
	if M.VISUAL_INDICATOR && M.USE_GUI,
        set(psylab_gui, 'Color', tempcolor);
    end

    % get user answer M.RE ("Recognized")
	M.RE = -1;
	while isempty(M.RE) || ~any(str2double(M.RE) == 1 : M.N_RECOGNITION + M.COMPAREWITHNONE)
        if ~isempty(M.RE)
            if ischar(M.RE) && (strcmp(M.RE, 'r') || strcmp(M.RE, 'e')) % check user answer for a possible quit-request
                return
            end
            if M.USE_GUI,   %% ----- user answers via mouse/GUI
                % a pause allows GUI-callbacks to be fetched
                set(afc_info, 'String', M.TASK);
                pause(0.5);  
                if isempty(M.RE),  re = -1;  end;
            else
                % prompt user for an answer via keyboard
                for count = 1 : M.N_RECOGNITION + M.COMPAREWITHNONE
                    display (sprintf('%d. %s', count, char(M.COMPRARE_NAMES(count))))
                end
                M.RE = input(M.TASK);
                if isempty(M.RE),  re = -1;  end;
            end
        else
            pause(0.5);
        end    
    end

    % save current answer
	M.ACT_ANSWER = str2double(M.RE);

    % check result of current answer
    if isfield(M, 'COMPAREWITHNONE') && M.COMPAREWITHNONE == 1 && M.ACT_ANSWER == M.N_RECOGNITION + M.COMPAREWITHNONE
        feedback = 'not recognized';
    elseif M.VAR == M.ACT_ANSWER
        feedback = 'correct';
    else
        feedback = 'not correct';
    end
  
	if M.FEEDBACK, % display feedback
        mpsy_info(M.USE_GUI, afc_fb, feedback);
        pause(1);
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

    M.RANDOMSTIMULI(1) = []; % delete the first stimuls in M.RANDOMSTIMULI
    if M.USE_GUI,
        figure(psylab_gui); % Focus on psylab_gui
        uicontrol(afc_info); % Workaround for focus-problem -> "afc_info" gets the focus (which has same KeyPressFcn as psylab_gui)
    end
end   % while length of M.RANDOMSTIMULI >= 1
% ---------------------------------------------
% ----- end of loop of trials for one run -----
% ---------------------------------------------

% protocol everything

% convert results to save them via mpsy_proto
tmp_VARS = M.VARS; % save vars in tmp_VARS-var
M.VARS = []; % clear vars
for count = 1 : M.N_RECOGNITION % loop through all stimuli
    idx = find(tmp_VARS == count); % find same stimuli (when M.LOOPS > 1)
    M.VARS(count) = sum(tmp_VARS(idx) == M.ANSWERS(idx)) / length(idx) * 100; % calculate mean correctness of one stimulus
end
M.ANSWERS = M.VARS; % save the mean correctness of all stimuli in M.ANSWERS
% when all M.STEPS equal M.MINSTEP, all results will be saved by mpsy_proto
% (without modifications)
M.MINSTEP = 1;
M.STEPS = ones(length(M.VARS),1) * M.MINSTEP; % 

varnametmp = M.VARNAME; % save current M.VARNAME 
varunittmp = M.VARUNIT; % save current M.VARUNIT
M.VARNAME = 'correct'; % set M.VARNAME to 'correct'
M.VARUNIT = 'percent'; % set M.VARUNIT to 'percent'
M.SAVEMEAN = 1; % when M.SAVEMEAN == 1, mpsy_proto will save the mean (instead of median)
mpsy_proto;
if M.FEEDBACK,  figure(111); mpsy_plot_feedback; end

M.VARNAME = varnametmp; % reset M.VARNAME 
M.VARUNIT = varunittmp; % reset M.VARUNIT 

mpsy_info(M.USE_GUI, afc_fb, '*** run completed ***');
pause(3);

% End of file:  mpsy_recognition_main.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
