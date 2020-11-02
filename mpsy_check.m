% Usage: y = mpsy_check()
%
% performs a check on certain PSYLAB variables in order to ensure that
% vital variables are properly set by the user and their values are of
% acceptable type/content prior to starting an experimental run
% 
%   input:   (none), acts on a set of global variables
%  output:   (none)
%
% Copyright (C) 2005 by Martin Hansen, Fachhochschule OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  08 Nov 2005
% Updated:  <15 Apr 2016 16:55, martin>
% Updated:  <23 Okt 2006 00:05, hansen>
% Updated:  < 8 Nov 2005 22:10, mh>

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


% --------------------------------------------------
% check for experiment using old psylab version via existence of
% old-style variable M_PARAM 
if exist('M_PARAM'),
  fprintf('*** You seem to try to run an experiment made for psylab version 1,\n');
  fprintf('*** while your psylab appears to be version %s. \n', mpsy_version);
  fprintf('*** You will probably need to change one or the other to a matching version.\n');
  warning('version mismatch of psylab version and your experiment files');
end

% --------------------------------------------------
% check for experiment using old style definition of adaptive procedure
if isfield(M, 'ADAPT_N_UP') & ~isfield(M, 'ADAPT_METHOD'),
  fprintf('*** You seem to try to run an experiment made for psylab version prior to 2.3,\n');
  fprintf('*** while your psylab appears to be version %s. \n', mpsy_version);
  fprintf('*** You will probably need to change one or the other to a matching version.\n');a
  warning('version mismatch of psylab version and your experiment files');
end

% field variables that must contain a string
mpsy_field_must_be_string = {'SNAME', 'VARNAME', 'VARUNIT'};

% field variables that must contain a numeric scalar value
if isfield(M, 'ADAPT_METHOD'),
  mpsy_field_must_be_scalar = {'VAR', 'STEP', 'MINSTEP', 'NUM_PARAMS'};
end
if isfield(M, 'CONSTSTIM_NUM_PRESENTATIONS'),
  mpsy_field_must_be_scalar = {'CONSTSTIM_NUM_PRESENTATIONS', 'NUM_PARAMS'};
end

% field variables that must contain a numeric value (scalar or vector)
mpsy_field_must_be_numeric = [mpsy_field_must_be_scalar, 'PARAM'];

% these field variables need to be cells (of stings), EVEN if only 1 element exist
mpsy_field_must_be_cell = {'PARAMNAME', 'PARAMUNIT'};


mpsy_field_must_not_be_empty = [mpsy_field_must_be_string mpsy_field_must_be_numeric];

% --------------------------------------------------
% check for empty variables
for tmp = mpsy_field_must_not_be_empty,
  tmp_varname = char(tmp);
 
  % check for existence first:
  if ~isfield(M, tmp_varname), 
    error('psylab-variable "M.%s" must exist and must not be empty!  \n',  tmp_varname);
  end
  % then check for emptiness:
  if isempty(getfield(M, tmp_varname)),
    error('psylab-variable "M.%s" must not be left empty! \n',  tmp_varname);
  end
end

% --------------------------------------------------
% check for numeric type variables
for tmp = mpsy_field_must_be_numeric,
  tmp_varname = char(tmp);
  if ~isnumeric(getfield(M, tmp_varname)),
    error('content of psylab-variable "M.%s" must be a numeric value!  \n',  tmp_varname);
  end
end

% --------------------------------------------------
% check for string type variables
for tmp = mpsy_field_must_be_string,
  tmp_varname = char(tmp);
  if ~ischar(getfield(M, tmp_varname)),
    error('psylab-variable "M.%s" must be a string!  \n', tmp_varname);
  end
  if strfind(getfield(M, tmp_varname), ' '),
    error('content of psylab-variable "M.%s" must not contain blank spaces!  ', tmp_varname);
  end
end

% --------------------------------------------------
% check for being scalar variables
for tmp = mpsy_field_must_be_scalar,
  tmp_varname = char(tmp);
  if ~isscalar(getfield(M, tmp_varname)),
    error('psylab-variable "M.%s" must be a scalar!  \n', tmp_varname);
  end
end


% --------------------------------------------------
% check for correct lengths of M.PARAM* variables
if length(M.PARAM) ~= M.NUM_PARAMS,
  error('length of M.PARAM must match value of M.NUM_PARAMS ');
end
if length(M.PARAMNAME) ~= M.NUM_PARAMS,
  error('length of M.PARAMNAME must match value of M.NUM_PARAMS ');
end
if length(M.PARAMUNIT) ~= M.NUM_PARAMS,
  error('length of M.PARAMUNIT must match value of M.NUM_PARAMS ');
end

% --------------------------------------------------
% check for cellstring type variables
for tmp = mpsy_field_must_be_cell,
  tmp_varname = char(tmp);
  tmp_val = getfield(M,tmp_varname);
  if ~iscellstr(tmp_val),
    error('psylab-variable "%s" must be a cell(string)!  \n', tmp_varname);
  end
  for k=1:M.NUM_PARAMS
    if strfind(char(tmp_val(k)), ' '),
      error('content of psylab-variable "%s(%d)" must not contain blank spaces!  \n', tmp_varname, k);
    end
    if length(char(tmp_val(k))) == 0,
      error('psylab-variable "%s(%d)" must not be empty!  \n', tmp_varname, k);
    end
  end
end


% --------------------------------------------------
% check type of experiment (e.g. n-AFC or matching) 
clear tmp_type; 
tmp_type(1) = isfield(M, 'NAFC');
tmp_type(2) = isfield(M, 'MATCH_ORDER');
tmp_type(3) = isfield(M, 'N_RECOGNITION');
if sum(tmp_type) ~= 1,
  error('exactly one of either M.NAFC or M.MATCH_ORDER or M.N_RECOGNITION must be set correctly');
end

% --------------------------------------------------
% check correct sign of M.STEP and M.MINSTEP
if isfield(M, 'ADAPT_METHOD'),
  if sign(M.STEP) ~= sign(M.MINSTEP),
    error('M.STEP and M.MINSTEP must have the same sign:  both positive for regular experiments, both negative for reversed-up-and-down experiment');
  end
end



% --------------------------------------------------
% check proper value of M.VISUAL_INDICATOR
if M.VISUAL_INDICATOR & ~M.USE_GUI,
  fprintf('\n*** INFO: the VISUAL_INDICATOR feature can only be used when using a GUI\n');
  warning('M.VISUAL_INDICATOR has been set to 0.');
  pause(2);
  M.VISUAL_INDICATOR = 0;
end

% --------------------------------------------------
% check proper value of M.NAFC
if isfield(M, 'NAFC') & M.NAFC ~= round(M.NAFC),
  error('field M.NAFC must contain an integer');
end


% --------------------------------------------------
% check version of psydat file, create correct header line 
% if file doesn't exist yet
M.PSYDAT_VERSION = mpsy_check_psydat_file( ['psydat_' M.SNAME] );
if M.PSYDAT_VERSION < 3,
  fprintf('\n\n*** You are using psylab with psydat file format version 3\n');
  fprintf('*** but you seem to have an existing psydat file in the current \n');
  fprintf('*** directory which is in version %d format.  \n', M.PSYDAT_VERSION); 
  fprintf('*** While your data would be saved without any loss, a mix of different\n')
  fprintf('*** data formats in the same psydat file would destroy its automatic\n')
  fprintf('*** readibility.\n');  
  fprintf('*** Possible solution: Store your old psydat file in a different directory \n');  
  fprintf('*** or move your experiment to another directory now and restart it there.\n')
  fprintf('*** Your psydat file in version 2 can be read and processed by the function \n')
  fprintf('*** "read_psydat_v2", while "read_psydat" will use psydat version 3\n')
  fprintf('*** \n')
  error('file "%s" in current directory seems to be in psydat format version %d', ...
        ['psydat_' M.SNAME], M.PSYDAT_VERSION );
end



% --------------------------------------------------
% ensure existence of pre-signal, quiet-signal, and post-signal
% - if not yet existent, then create empty signals
% - if existent but a scalar value, then generate silence signals
%
% For the generation of silence signals, we need to know the number
% of channels (mono, stereo, ...).  In order to determine that
% number of channels, run the user-script once here and check the
% size of the signal m_test which will then have been generated:
eval([M.EXPNAME 'user']); 
numchannels = size(m_test, 2);

if exist('m_quiet')~=1,   
  m_quiet   = [];  
else
  if isscalar(m_quiet),
    m_quiet = zeros(round(m_quiet*M.FS), numchannels);
  end
end
if exist('m_presig')~=1,  
  m_presig  = [];  
else
  if isscalar(m_presig),
    m_presig = zeros(round(m_presig*M.FS), numchannels);
  end
end
if exist('m_postsig')~=1, 
  m_postsig = [];  
else
  if isscalar(m_postsig),
    m_postsig = zeros(round(m_postsig*M.FS), numchannels);
  end
end



% --------------------------------------------------
% create gui or get the handle for the afc gui 
if M.USE_GUI,
  htmp = findobj('Tag', 'psylab_answer_gui');
  if isempty(htmp),
    % in case of first run or in case the answer-gui got cleared/closed 
    % unintentionally by the test subject:  create a fresh one.  
    if isfield(M, 'NAFC') & M.NAFC >= 2,
      if isfield(M, 'ADAPT_METHOD') & strcmp(M.ADAPT_METHOD, 'uwud'),
        % seems like we have an unforced choice n-AUC experiment
        eval( ['mpsy_' num2str(M.NAFC) 'auc_gui;'] );
      else
        % seems like we have an n-AFC experiment
        eval( ['mpsy_' num2str(M.NAFC) 'afc_gui;'] );
      end
      
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
    
    if isfield(M, 'NAFC')
      % in case of ACF experiment, also get the handles for the interval 
      % buttons, as they are needed by mpsy_visual_interval_indicator.m   
      for kk=1:M.NAFC
        afc_but(kk) = findobj('Tag',['afc_answer' num2str(kk)] );
    
        % $$$       afc_but(1) = findobj('Tag','afc_answer1');
        % $$$       afc_but(2) = findobj('Tag','afc_answer2');
        % $$$       afc_but(3) = findobj('Tag','afc_answer3');
        % $$$       afc_but(4) = findobj('Tag','afc_answer4');
      end
    else
      % in case of a matching experiment, get the two button handles
      afc_but(1) = findobj('Tag','ButDOWN');
      afc_but(2) = findobj('Tag','ButUP');
    end
    
  end
end




% End of file:  mpsy_check.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
