% a GUI for the recording answers of the test subject in 2- interval 3-AFC tasks 

% This file is based on mpsy_3afc_gui by Martin Hansen. 
% Modified to create a gui for 2-Interval 3-AFC procedure.
% Copyright (C) 2007       G.Stiefenhofer
% Author :  G.Stiefenhofer
% Date   :  December 2007

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

% and place the three buttons for the three alternative user answers
% (variable 'M.UA')

if isfield(M,'INAFC_GUISTR') % get the strings for the 3-AFC buttons
    str1 = M.INAFC_GUISTR(1);
    str2 = M.INAFC_GUISTR(2);
    str3 = M.INAFC_GUISTR(3);
else
    str1 = '1';
    str2 = '2';
    str3 = '3';
end
afc_b1 = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.1 0.45 0.2 0.2], ...
	'Callback','M.UA=1;', ...
	'Tag','afc_answer1', ...
	'String',str1, 'FontSize', 14);
afc_b2 = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.4 0.45 0.2 0.2], ...
	'Callback','M.UA=2;', ...
	'Tag','afc_answer2', ...
	'String',str2, 'FontSize', 14);
afc_b3 = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.7 0.45 0.2 0.2], ...
	'Callback','M.UA=3;', ...
	'Tag','afc_answer3', ...
	'String',str3, 'FontSize', 14);

if ~isfield(M,'WRONGBUTTON')
    M.WRONGBUTTON = M.TASK;
end

% 2 new buttons, to display which interval (1 or 2) is currently played
% if a subject pushs one of these buttons, display M.WRONGBUTTON in gui.
afc_i1 = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.3 0.85 0.4 0.1], ...
	'Tag','afc_i1', ...
	'String','1', 'FontSize', 14, 'Callback',' M.UA = -100;');
afc_i2 = uicontrol('Parent', psylab_gui, ...
	'Unit','normalized', 'Position',[0.3 0.75 0.4 0.1], ...
	'Tag','afc_i2', ...
	'String','2', 'FontSize', 14,...
    'Callback','M.UA=-100;');
