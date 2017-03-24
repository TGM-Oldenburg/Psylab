function user_answer = mpsy_query_user(flag_use_gui, guihandle, question) 

% Usage: user_answer = mpsy_query_user(flag_use_gui, guihandle, question)
% ----------------------------------------------------------------------
%
% query the user with some question
%
%   input:   
%     flag_use_gui  Flag whether output into GUI (1) or on screen (0)
%     guihandle     Handle to text field inside GUI; not used in case ~flag_use_gui
%     question      The question/query/text to be asked
%  output: 
%     user_answer   The user answer, as a 1-char value.  
%
%
% Copyright (C) 2017 by Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  11 Feb 2017
% Updated:  <11 Feb 2017 19:12, martin>

%% This file is part of PSYLAB, a collection of scripts for
%% designing and controlling interactive psychoacoustical listening
%% experiments.  
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl


if nargin < 3, help(mfilename); return; end;


% display the question via mpsy_info
mpsy_info(flag_use_gui, guihandle, question);


user_answer = -1;   % value -1 is an internal flag for "not yet changed"

if flag_use_gui,
  
  % this can only be called when there actually _is_ a GUI with a handle to it:
  guidata(guihandle, user_answer)
  
  set(guihandle, 'String', question);
  % the variable 'M.UA' for the user answer gets set via
  % KeyPressFcn of the GUI.  Actually, not only RET but also any
  % key will lead to exit from the following while loop. The pause
  % is essential for catching GUI events 
  while user_answer == -1,    
    pause (0.5);  
    user_answer = guidata(guihandle);
  end;   
  set(guihandle, 'String', '');
  
else
  
  % the question has already been output by mpsy_info, so use
  % "input" without further text
  user_answer = input([' ']);
  
end


% End of file:  mpsy_query_user.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
