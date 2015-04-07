% Usage: y = mpsy_check()
%
% performs a check on certain PSYLAB variables in order to ensure that
% vital variables are properly set by the user and their values are of
% acceptable type/content prior to starting an experimental run
% 
%   input:   (none), acts on a set of global variables
%  output:   (none)
%
% This file was modified by Georg Stiefenhofer to allow 2-interval 3-AFC
% procedures.
% Copyright (C) 2005 by Martin Hansen, Fachhochschule OOW
% Author :  Martin Hansen <psylab AT fh-oldenburg.de>
% Date   :  08 Nov 2005
% Updated:  <23 Okt 2006 00:05, hansen>
% Updated:  < 8 Nov 2005 22:10, mh>
% Modified: November 2007, G. Stiefenhofer:

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


% check for experiment using old psylab version via existence of
% old-style variable M_PARAM 
if exist('M_PARAM'),
  fprintf('*** you seem to try to run an experiment made for psylab version 1,\n');
  fprintf('*** while your psylab appears to be version %s \n', mpsy_version);
  fprintf('*** you will probably need to change one or the other to a matching version.\n');a
  warning('version mismatch of psylab version and your experiment files');
end


% variables that must contain a string
mpsy_must_be_string = {'M.SNAME', 'M.VARNAME', 'M.VARUNIT'};

% variables that must contain a numeric value ...
mpsy_must_be_numeric = {'M.VAR', 'M.STEP', 'M.NUM_PARAMS'};

% ... or numeric values as a scalar or vector
mpsy_scalar_or_vector = {'M.PARAM'};

% these variables need to be cells (of stings), EVEN if only 1 element exist
mpsy_must_be_cell = {'M.PARAMNAME', 'M.PARAMUNIT'};


mpsy_must_not_be_empty = [mpsy_must_be_string mpsy_must_be_numeric mpsy_scalar_or_vector];

% check for empty variables
for tmp = mpsy_must_not_be_empty,
  tmp_varname = char(tmp);
  if ~isfield(M, tmp_varname(3:end)) | isempty(tmp_varname),
    error('psylab-variable "%s" must not be left empty! ',  tmp_varname);
  end
end

% check for numeric type variables
for tmp = [mpsy_must_be_numeric  mpsy_scalar_or_vector],
  tmp_varname = char(tmp);
  tmp_val = eval(tmp_varname);
  %if ~isnumeric(tmp_val) | max(size(tmp_val)) > 1,
  if ~isnumeric(tmp_val),
    error('content of psylab-variable "%s" must be a scalar numeric value! ',  tmp_varname);
  end
end

% check for string type variables
for tmp = mpsy_must_be_string,
  tmp_varname = char(tmp);
  tmp_val = eval(tmp_varname);
  if ~ischar(tmp_val),
    error('psylab-variable "%s" must be a string! ', tmp_varname);
  end
  if strfind(tmp_val, ' '),
    error('content of psylab-variable "%s" must not contain blank spaces! ', tmp_varname);
  end
end

% check for cellstring type variables
for tmp = mpsy_must_be_cell,
  tmp_varname = char(tmp);
  tmp_val = eval(tmp_varname);
  if ~iscellstr(tmp_val),
    error('psylab-variable "%s" must be a cell(string)! ', tmp_varname);
  end
  for k=1:M.NUM_PARAMS
    if strfind(char(tmp_val(k)), ' '),
      error('content of psylab-variable "%s" must not contain blank spaces! ', tmp_varname);
    end
  end
end

if length(M.PARAM) ~= M.NUM_PARAMS,
  error('length of M.PARAM must match value of M.NUM_PARAMS');
end
if length(M.PARAMNAME) ~= M.NUM_PARAMS,
  error('length of M.PARAMNAME must match value of M.NUM_PARAMS');
end
if length(M.PARAMUNIT) ~= M.NUM_PARAMS,
  error('length of M.PARAMUNIT must match value of M.NUM_PARAMS');
end


%% --------------------------------------------------
% check version of psydat file, create correct header line 
% if file doesn't exist yet
M.PSYDAT_VERSION = mpsy_check_psydat_version( ['psydat_' M.SNAME] );
if M.PSYDAT_VERSION == 1,
  fprintf('\n\n*** you are using psylab with psydat format version 2\n');
  fprintf('*** but you seem to have an existing psydat file in the current \n');
  fprintf('*** directory which is in version 1 format.  Mixing the formats\n'); 
  fprintf('*** in one file would screw up its readibility.  \n');
  fprintf('*** Possible solution: move your experiment to another directory now\n')
  fprintf('*** and restart it there.\n')
  error('file "%s" in current directory seems to be in psydat format version 1', ['psydat_' M.SNAME] );
end


%% --------------------------------------------------
%% ensure existence of pre-signal, quiet-signal, and post-signal
%% if not yet existent, create empty signals
if exist('m_quiet')~=1,   m_quiet   = [];  end
if exist('m_presig')~=1,  m_presig  = [];  end
if exist('m_postsig')~=1, m_postsig = [];  end

%% --------------------------------------------------
%% check type of experiment (e.g. n-AFC or matching) 
clear tmp_type; 
tmp_type(1) = isfield(M, 'NAFC');
tmp_type(2) = isfield(M, 'MATCH_ORDER');
if sum(tmp_type) ~= 1,
  error('exactly one of either M.NAFC or M.MATCH_ORDER must be set correctly');
end

%% --------------------------------------------------
%% create gui or get the handle for the afc gui 
if isfield(M, 'INAFC') && M.INAFC ~= 2;
    error('Sorry, right now for n-interval m-AFC procedures, m must be 3 and n must be 2! ')
end
if M.USE_GUI,
  htmp = findobj('Tag', 'psylab_answer_gui');
  if isempty(htmp),
    % in case of first run or in case the answer-gui got cleared/closed 
    % unintentionally by the test subject:  create a fresh one.  
    if isfield(M, 'NAFC') && M.NAFC >= 2 && ~isfield(M, 'INAFC')
      % seems like we have an n-AFC experiment
      eval( ['mpsy_' num2str(M.NAFC) 'afc_gui;'] );
    elseif isfield(M, 'NAFC') && M.NAFC >= 2 && M.INAFC == 2  
       % seems like we have an m-Interval n-AFC exp. (NOTE: here m must be 2)
       eval( ['mpsy_2i' num2str(M.NAFC) 'afc_gui;'] );
    elseif isfield(M, 'MATCH_ORDER') & M.MATCH_ORDER >= 0,
      % seems like we have a matching experiment
      mpsy_up_down_gui;
    end
    
  else 
    % the answer-gui is already/still there, 
    % so just place it visibly in the foreground 
    figure(htmp);
    % get the handles for the feedback/info text in case they got cleared
    afc_fb = findobj('Tag','psylab_feedback'); 
    afc_info = findobj('Tag','psylab_info'); 
    % also get the handles for the interval buttons, as they are needed
    % by mpsy_visual_indicator.m   
    afc_b1 = findobj('Tag','afc_answer1');
    afc_b2 = findobj('Tag','afc_answer2');
    afc_b3 = findobj('Tag','afc_answer3');
    afc_b4 = findobj('Tag','afc_answer4');
    afc_i1 = findobj('Tag','afc_i1');
    afc_i2 = findobj('Tag','afc_i2');
    
  end
end



% End of file:  mpsy_check.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
