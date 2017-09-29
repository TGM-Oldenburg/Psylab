function user_answer = mpsy_get_useranswer(M, usermsg, guihandle) 

% Usage: user_answer = mpsy_get_useranswer(M, usermsg, guihandle)
% ----------------------------------------------------------------------
%
% query the current answer from the user
%
%   input:   
%     M, a struct variable with, amongst others, these field variables:
%       M.USEGUI     flag whether or not to use the GUI for user input 
%       M.TASK       the task/question for the subject, as a string
%       M.ALLOWED_USER_ANSWERS  [optional] 
%                    array of allowed values for the user answer, e.g.  [1 2
%                    3] for a 3-AFC experiment. If omitted, the default is
%                    that any answer/key press is allowed.
%     usermsg        [optional]  
%                    The message/question to be displayed to the subject.
%                    If omitted, then the content of M.TASK will be used. 
%     guihandle      [optional]   
%                    The gui element handle where the usermsg should be
%                    displayed.  If omitted, the handle "afc_info" will be used.
%
%  output: 
%      user_answer   The user answer, as a 1-char value.  
%
%
% Copyright (C) 2016 by Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  04 Nov 2016
% Updated:  <30 Aug 2017 11:38, martin>   optional 2nd output argument
% Updated:  < 7 Nov 2016 15:51, martin>
% Updated:  < 6 Nov 2016 15:42, martin>

%% This file is part of PSYLAB, a collection of scripts for
%% designing and controlling interactive psychoacoustical listening
%% experiments.  
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl


if nargin < 1, help(mfilename); return; end;

if nargin < 2,
  usermsg = M.TASK;
end


if ~isfield(M, 'ALLOWED_USER_ANSWERS') | isempty(M.ALLOWED_USER_ANSWERS),
  % button presses on the GUI will call the figure's "KeyPressFcn"
  % which returns the (remapped) CurrentCharacter, as a double. 
  % Allow all answers:
  M.ALLOWED_USER_ANSWERS = [-35:256];  
end

% set the user answer to an intial value which indicates:  
% no new/allowed answer given so far 
user_answer = -1 + min(M.ALLOWED_USER_ANSWERS);

if M.USE_GUI,
  if nargin < 3,
    guihandle = findobj('Tag','psylab_info');
  end
  % this can only be called when there actually _is_ a GUI with a handle to it
  guidata(guihandle, user_answer);
end


while  ~any( user_answer == M.ALLOWED_USER_ANSWERS),
  if M.USE_GUI,   %% ----- user answers via mouse/GUI
    set(guihandle, 'String', usermsg);
    % The following "pause" allows GUI-callbacks to be fetched.
    % Several callbacks defined in mpsy_afc_gui set the variable
    % M.UA and also use guidata to store the value of M.UA
    pause(0.2);  
    user_answer = guidata(guihandle);
  else
    % prompt user for an answer via keyboard
    user_answer = input(usermsg);
  end    
  if isempty(user_answer),  user_answer = -1;  end;
  
end


% End of file:  mpsy_get_useranswer.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
