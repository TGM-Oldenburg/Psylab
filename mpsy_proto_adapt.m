% Usage: mpsy_proto_adapt()
% ----------------------------------------------------------------------
%          Protocols the results of the previous adaptive run:
%          plots M.VAR as a function of trial number,
%          writes a corresponding result line into the "psydat"
%          file, in psydat format version 3.
%          In case M.DEBUG > 0,  all variables M.* are saved in a
%          separate mat-file which can be useful for debugging
% 
%   input args:  (none) works on set of global variables M.* 
%  output args:  (none) processes subjects' answer and protocolls everything
%
% Copyright (C) 2003, 2004   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  23 May 2003

% Updated:  <21 Feb 2017 10:33, mh>
%           Change of filename from mpsy_proto (for version <= 2.7)
%           to mpsy_proto_adapt (for version >= 2.8)
% Updated:  <25 Okt 2016 09:36, mh>
%           Changed output line of a trial in psydat file
%           slightly:  Instead of "####" as a marker in the first column, it
%           is now "##adapt##" in order to specify the type of experiment.  
% Updated:  <20 Jul 2015 12:29, mh>
%           added option for saving all values of M.VARS during one
%           run.  Original idea/commit by Stephanus Volke
% Updated:  <13 Nov 2007 Sven Franz>
%           added var "M.SAVEMEAN". When M.SAVEMEAN==1 the mean (not
%           median) will be saved
% Updated:  < 6 Jan 2006 20:07, mh>

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


% determine the trial indices of the measurement phase, i.e. where the
% familiarization phase is finished, and the step size has reached its
% minimum value:
M.measurement_fidx = find(M.STEPS == M.MINSTEP);

% calculate mean, median etc. of the stimulus variable during measurement phase:
M.med_thres  = median (M.VARS(M.measurement_fidx)); % THIS is defined as threshold by default
M.mean_thres =   mean (M.VARS(M.measurement_fidx)); % THIS can be defined as threshold, see below
M.std_thres  =    std (M.VARS(M.measurement_fidx));
M.min_thres  =    min (M.VARS(M.measurement_fidx));
M.max_thres  =    max (M.VARS(M.measurement_fidx));

% for plotting in mpsy_plot_feedback we also need these indices
M.familiarization_fidx = find(M.STEPS ~= M.MINSTEP);


% Now output all relevant information to a text protocol file
% this is done in the psydat format version 3 
%
% N.B. the order of the information in the following output DOES matter,
%       as read_psydat.m and psydat_helper.m rely on it. 
%
[fidm,message] = fopen( ['psydat_',M.SNAME], 'a' );

fprintf(fidm,'##adapt## %s %s %s__%s npar %d ####\n', ...
	M.EXPNAME, M.SNAME, datestr(now,1), datestr(now,13), M.NUM_PARAMS);
for k=1:M.NUM_PARAMS,
  fprintf(fidm,'%%%%----- PAR%d: %s %f %s\n', k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)));
end  

% output the information about the adaptive method used
fprintf(fidm, '%%%%----- ADAPT:');
fprintf(fidm,' %s', M.ADAPT_METHOD);
if isfield(M, 'PC_CONVERGE'),
  fprintf(fidm,'  %.4f \n', M.PC_CONVERGE);
else
  fprintf(fidm,' \n');
end


% if flag-variable M.SAVERUN has been set accordingly, output the
% individual values of M.VAR and the answers to the psydat file.  
if (isfield(M, 'SAVERUN')) & M.SAVERUN == 1
  fprintf(fidm, '%%%%----- VAL:');
  for k = 1:length(M.ANSWERS)
    fprintf(fidm, ' %g %d', M.VARS(k), M.ANSWERS(k));
  end
  fprintf(fidm, '\n');
end

if (isfield(M, 'SAVEMEAN')) & M.SAVEMEAN == 1
    fprintf(fidm,'  %s %f %f %f %f %s\n', ...
        M.VARNAME, M.mean_thres, M.std_thres, M.min_thres, M.max_thres, M.VARUNIT);
else
    fprintf(fidm,'  %s %f %f %f %f %s\n', ...
        M.VARNAME, M.med_thres, M.std_thres, M.min_thres, M.max_thres, M.VARUNIT);
end
fclose(fidm);


% ------------------------------------------------------------
% add new values pertaining to last run to the collection of
% parameters and thresholds:  lowercase variable names are used to
% show that these do not contain user-specified values

% add this run's median threshold value (median of M_VAR during measurement phase
% of last run) to collection
if ~isfield(M, 'allthres_med'),
  % hm, this seems to be the first completed run during this experiment
  M.allthres_med = M.med_thres ;   
else  
  % append a row
  M.allthres_med = [ M.allthres_med; M.med_thres ];  
end
% add this run's mean threshold value (mean of M_VAR during measurement phase
% of last run) to collection
if ~isfield(M, 'allthres_mean'),
  % hm, this seems to be the first completed run during this experiment
  M.allthres_mean = M.mean_thres ;   
else  
  % append a row
  M.allthres_mean = [ M.allthres_mean; M.mean_thres ];
end
% add this threshold's standard deviation (std.dev. of M_VAR during
% measurement phase of last run) to collection
if ~isfield(M, 'allthres_std'),
  % hm, this seems to be the first completed run during this experiment
  M.allthres_std = M.std_thres ;
else  
    % append a row
    M.allthres_std = [ M.allthres_std; M.std_thres ]; 
end
% add the set of values of all parameters of the current run, as a
% row vector, to the collection of parameter sets (of all runs)
if ~isfield(M, 'allparam'),
  % hm, this seems to be the first completed run during this experiment
  M.allparam = M.PARAM(:).';    % force a ROW shape
else
  % different values of the same parameter from different runs form
  % a column, so there will be M.NUM_PARAMS columns in M.ALLPARAM
  M.allparam  = [ M.allparam; M.PARAM(:).' ];  % append a row
end


if M.DEBUG>0,
  mpsy_debug_savefile
end

% 
if M.FEEDBACK,
  fprintf('  Result:  Parameter (%s): %g %s,\n', ...
           char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
  for k=2:M.NUM_PARAMS,
    fprintf('           Param.%d   (%s): %g %s,\n', ...
             k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)));
  end  
  fprintf('           Threshold (%s) Median: %g %s,  STD: %g %s \n\n', ...
	  M.VARNAME, M.med_thres, M.VARUNIT, M.std_thres, M.VARUNIT);
end


% End of file:  mpsy_proto_adapt.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
