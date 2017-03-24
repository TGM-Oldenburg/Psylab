function user_answer = mpsy_get_useranswer(M) 

% Usage: user_answer = mpsy_get_useranswer(M)
% ----------------------------------------------------------------------
%
% query the current answer from the user
%
%   input:   
%     M, a struct variable with, amongst others, these field variables:
%       M.USEGUI      flag whether or not to use the GUI for user input 
%       M.TASK        task for the subject, as a string
%       M.ALLOWED_USER_ANSWERS  [optional] array of allowed values for the
%                     user answer, e.g.  [1 2 3] for a 3-AFC experiment.
%                     If omitted, any answer/key press is allowed
%
%  output: 
%      user_answer           The user answer, as a 1-char value.  
%
%
% Copyright (C) 2016 by Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  04 Nov 2016
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
if ~isfield(M, 'ALLOWED_USER_ANSWERS'),
  % button presses on the GUI will call the figure's "KeyPressFcn"
  % which returns the (remapped) CurrentCharacter, as a double. 
  % Allow all answers:
  M.ALLOWED_USER_ANSWERS = [-35:256];  
end


handle_afc_info = findobj('Tag','psylab_info');

% set the user answer to -1 to indicate:  no new/allowed answer given so far
user_answer = -1;
if M.USE_GUI,
  % this can only be called when there actually _is_ a GUI with a handle to it
  guidata(handle_afc_info, user_answer);
end

while  ~any( user_answer == M.ALLOWED_USER_ANSWERS),
  if M.USE_GUI,   %% ----- user answers via mouse/GUI
    set(handle_afc_info, 'String', M.TASK);
    % The following "pause" allows GUI-callbacks to be fetched.
    % Several callbacks defined in mpsy_afc_gui set the variable
    % M.UA and also usesguidata to store the value of M.UA
    pause(0.2);  
    user_answer = guidata(handle_afc_info);
  else
    % prompt user for an answer via keyboard
    user_answer = input(M.TASK);
  end    
  if isempty(user_answer),  user_answer = -1;  end;
  
end


% End of file:  mpsy_get_useranswer.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
