% a GUI for answers of the test subject in 2 Alternative UNforced Choice
%
% Usage: mpsy_2auc_gui
%
% Copyright (C) 2009  Martin Hansen  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  24 Sep 2009
% Updated:  <10 Nov 2009 11:25, mh>

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

ptmp = get(psylab_gui, 'Position');
set(psylab_gui, 'Position', max(ptmp, [0 0 700 0] ));

% place the "indecision" button ("I don't know") at the left side
afc_ind = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.1 0.5 0.18 0.3], ...
	'Callback','M.UA=-3;', ...
	'Tag','afc_indecision', ...
	'String','I don''t know', 'FontSize', 14);



% and place the three buttons for the three alternative user answers
% (variable 'M.UA')
afc_but(1) = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.35 0.5 0.25 0.3], ...
	'Callback','M.UA=1;', ...
	'Tag','afc_answer1', ...
	'String','1', 'FontSize', 14);
afc_but(2) = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.65 0.5 0.25 0.3], ...
	'Callback','M.UA=2;', ...
	'Tag','afc_answer2', ...
	'String','2', 'FontSize', 14);


% End of file:  mpsy_2auc_gui.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
