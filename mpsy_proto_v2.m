% Usage: mpsy_proto()
% ----------------------------------------------------------------------
%          Protocols the results of the previous adaptive run,
%              -- IN PSYDAT VERSION 2 FILE FORMAT --
%          plots M.VAR as a function of trial number
%          writes a corresponding result line into the "psydat"
%          file, in new psydat format version 2.
%          saves all variables M.* to disk.
%
%          Up to version 2.6, THIS file was called mpsy_proto.m
%   
% 
%   input args:  (none) works on set of global variables M.* 
%  output args:  (none) processes subjects' answer and protocolls everything
%
% Copyright (C) 2003, 2004   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  23 May 2003

% Updated:  < 6 Jan 2006 20:07, mh>
% Updated:  < 6 Jan 2006 20:07, mh>
% Updated:  <13 Nov 2007 Sven Franz>
%           added var "M.SAVEMEAN". When M.SAVEMEAN==1 the mean (not
%           median) will be saved
% Updated:  <20 Jul 2015 12:29, mh>
%           added option for saving all values of M.VARS during one
%           run.  Original idea/commit by Stephanus Volke

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

% calculate mean, median etc. of the variable during measurement phase:
M.med_thres  = median (M.VARS(M.measurement_fidx)); % THIS is defined as threshold by default
M.mean_thres =   mean (M.VARS(M.measurement_fidx)); % THIS can be defined as threshold, see below
M.std_thres  =    std (M.VARS(M.measurement_fidx));
M.min_thres  =    min (M.VARS(M.measurement_fidx));
M.max_thres  =    max (M.VARS(M.measurement_fidx));

% for plotting in mpsy_plot_feedback we also need these indices
M.familiarization_fidx = find(M.STEPS > M.MINSTEP);


% now output all relevant information to a text protocol file
% this is done in the psydat format version 2 
%
% N.B. the order of the following information output DOES matter,
%       as read_psydat.m and psydat_helper.m rely on it. 
%
[fidm,message] = fopen( ['psydat_',M.SNAME], 'a' );
fprintf(fidm,'#### %s %s %s__%s npar %d ####\n', ...
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


% output the individual values of M.VAR and the answers to the
% psydat file, if flag-variable M.SAVERUN has been set accordingly  
if (isfield(M, 'SAVERUN')) & M.SAVERUN == 1
  fprintf(fidm, '%%%%----- VAL:');
  for k = 1:length(M.ANSWERS)
    fprintf(fidm, ' %g %d',M.VARS(k), M.ANSWERS(k));
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
% parameters and thresholds:

% add this run's median threshold value (median of M_VAR during measurement phase
% of last run) to collection
if ~isfield(M, 'ALLTHRES_MED'),
  % hm, this seems to be the first completed run during this experiment
  M.ALLTHRES_MED = M.med_thres ;   
else  
  M.ALLTHRES_MED = [ M.ALLTHRES_MED; M.med_thres ];  % create column
end
% add this run's mean threshold value (mean of M_VAR during measurement phase
% of last run) to collection
if ~isfield(M, 'ALLTHRES_MEAN'),
  % hm, this seems to be the first completed run during this experiment
  M.ALLTHRES_MEAN = M.mean_thres ;   
else  
  M.ALLTHRES_MEAN = [ M.ALLTHRES_MED; M.mean_thres ];  % create column
end
% add this threshold's standard deviation (std.dev. of M_VAR during
% measurement phase of last run) to collection
if ~isfield(M, 'ALLTHRES_STD'),
  % hm, this seems to be the first completed run during this experiment
  M.ALLTHRES_STD = M.std_thres ;
else  
  M.ALLTHRES_STD = [ M.ALLTHRES_STD; M.std_thres ];  % create column
end
% add the set of values of all parameters of the current run, as a
% row vector, to the collection parameter sets.  
if ~isfield(M, 'ALLPARAM'),
  % hm, this seems to be the first completed run during this experiment
  M.ALLPARAM = M.PARAM(:).';    % force a ROW shape
else
  % different values of the same parameter from different runs form
  % a column, so there will be M.NUM_PARAMS columns in M.ALLPARAM
  M.ALLPARAM  = [ M.ALLPARAM; M.PARAM(:).' ];  
end

M.DATE = datestr(now);


if M.DEBUG>0,
  % setup filename with date/time info for saving in matlab format
  m_filenamedate = ['psy_' M.SNAME '_'];
  dv=datevec(now);
  for k=1:3,
    m_filenamedate = [ m_filenamedate sprintf('%2.2d',mod(dv(k),100)) ];
  end
  %if exist( [ m_filenamedate '.mat' ], 'file'),
  % add current hour to end of filename
  m_filenamedate = [ m_filenamedate '-' sprintf('%2.2d',dv(4))];
  %end
  % now save it:
  save(m_filenamedate, 'M', 'M_*')
end

% 
if M.FEEDBACK,
  fprintf('  Result:  Parameter (%s): %g %s,\n', char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
  for k=2:M.NUM_PARAMS,
    fprintf('           Par.%d (%s): %g %s,\n', k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)));
  end  
  fprintf('           Threshold (%s) Median: %g %s,  STD: %g %s \n\n', ...
	  M.VARNAME, M.med_thres, M.VARUNIT, M.std_thres, M.VARUNIT);
end


% End of file:  mpsy_proto.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
