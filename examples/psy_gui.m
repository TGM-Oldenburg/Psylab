% a GUI for the recording answers of the test subject in 3 AFC tasks 
%
% Usage: mpsy_3afc_gui
%
% Copyright (C) 2003, 2004   Martin Hansen  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  29 Sep 2003
% Updated:  < 3 Apr 2005 20:48, mh>
% Updated:  <14 Jan 2004 11:30, hansen>

%% This file is part of PSYLAB, a collection of scripts for
%% designing and controlling interactive psychoacoustical listening
%% experiments.  
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.  See the GNU General
%% Public License for more details:  http://www.gnu.org/licenses/gpl
%% This file is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY.
%% PSYLAB is written in MATLAB, based on many ideas and concepts 
%% of its predecessor SISG/SI, a system originally written 
%% by Dirk Pueschel, Rene Koch, and Ralf Fassel in 1989-1991.


rand('state', sum(100*clock));

%% ===== the GUI for querying the user answer =====
%% The contents of the 'Tag'-property is a RESERVED WORD, DO NOT CHANGE!
f_gui = figure('Color', 0.1*round(10*rand(1,3)), ...
	'Position',[9 37 1010 708], ...
	'Name','FH Sommerfest - Hörtest  --  © M. Hansen, FH OOW', ...
    'Tag', 'psy_gui', ...
	'NumberTitle','off', ...
	'Toolbar','None', ...
	'Menubar','None');

% the three buttons for the three alternative user answers
% (variable 'ua')
f_test1 = uicontrol('Parent', f_gui, ...
	'Unit','normalized', 'Position',[0.1 0.1 0.3 0.1], ...
	'Callback','ex = ''intensity''; psy_test;', ...
	'String','Intensity JND', ...
    'FontSize', 24);
f_test2 = uicontrol('Parent', f_gui, ...
	'Unit','normalized', 'Position',[0.6 0.1 0.3 0.1], ...
	'Callback','ex = ''frequency''; psy_test;', ...
	'String','Frequency JND', ...
    'FontSize', 24);

f_ax = axes('Parent', f_gui, ...
	'Unit','normalized', 'Position',[0.2 0.3 0.6 0.6],...
    'Tag', 'psy_gui_axes')

% End of file:  mpsy_3afc_gui.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
