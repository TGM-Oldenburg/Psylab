% a GUI for the recording answers of the test subject in 4 AFC tasks 
%
% Usage: mpsy_4afc_gui
%
% Copyright (C) 2003, 2004   Martin Hansen  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  3 Apr 2005
% Updated:  < 7 Nov 2016 15:04, martin>
%           added call to guidata in callback functions, to also let
%           the figure store the last user answer in its guidata
% Updated:  < 6 Jan 2006 21:11, mh>

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


% create the general GUI
mpsy_afc_gui;

% and place the four buttons for the four alternative user answers
% (variable 'M.UA')
afc_but(1) = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.1 0.55 0.125 0.3], ...
	'Callback','M.UA=1; guidata(psylab_gui, M.UA);', ...
	'Tag','afc_answer1', ...
	'String','1', 'FontSize', 14);
afc_but(2) = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.325 0.55 0.125 0.3], ...
	'Callback','M.UA=2; guidata(psylab_gui, M.UA);', ...
	'Tag','afc_answer2', ...
	'String','2', 'FontSize', 14);
afc_but(3) = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.55 0.55 0.125 0.3], ...
	'Callback','M.UA=3; guidata(psylab_gui, M.UA);', ...
	'Tag','afc_answer3', ...
	'String','3', 'FontSize', 14);
afc_but(4) = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.775 0.55 0.125 0.3], ...
	'Callback','M.UA=4; guidata(psylab_gui, M.UA);', ...
	'Tag','afc_answer4', ...
	'String','4', 'FontSize', 14);


% End of file:  mpsy_4afc_gui.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
