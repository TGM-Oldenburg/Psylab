% Usage: mpsy_proto()
% ----------------------------------------------------------------------
%          Protocols the results of the previous run:
%          plots M.VAR as a function of trial number
%          writes a corresponding result line into the "psydat"
%          file, in new psydat format version 2.
%          saves all variables M.* to disk
% 
%   input args:  (none) works on set of global variables M.* 
%  output args:  (none) processes subjects' answer and protocolls everything
%
% This file is based on the existing mpsy_proto.m by Martin Hanses and
% was modified by Georg Stiefenhofer.
% NOTE: save now mean isnted of median 
%
% Author :  G. Stiefenhofer, 
% Date   :  November 2007

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

if M.FIX_PROCDR
    fidx = 1:length(M.VARS);
else
    fidx = find(M.STEPS == M.MINSTEP);
end

mean_thres =   mean (M.VARS(fidx));
med_thres  = median (M.VARS(fidx));
std_thres  =    std (M.VARS(fidx));
%NOTE: computing a SD from binary data (1=correct, 0=incorrect) is kind of
% useless, isn't? However, in the display_psydat routine the SD is replaced
% by a SD over all experiment runs anyway. So in the end it will make
% sense.
min_thres  =    min (M.VARS(fidx));
max_thres  =    max (M.VARS(fidx));



% output to text protocol file
% this is done in the NEW psydat format version 2 
[fidm,message] = fopen( ['psydat_',M.SNAME], 'a' );
fprintf(fidm,'#### %s %s %s__%s npar %d ####\n', ...
	M.EXPNAME, M.SNAME, datestr(now,1), datestr(now,13), M.NUM_PARAMS);
for k=1:M.NUM_PARAMS,
  fprintf(fidm,'%%%%----- PAR%d: %s %f %s\n', k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)));
end  
fprintf(fidm,'  %s %f %f %f %f %s\n', ...
	M.VARNAME, mean_thres, std_thres, min_thres, max_thres, M.VARUNIT);
fclose(fidm);


% ------------------------------------------------------------
% add new values pertaining to last run to the collection of
% parameters and thresholds:

% add this threshold value (median of M_VAR during measurement phase
% of last run) to collection
if ~isfield(M, 'ALLTHRES_MED'),
  % hm, this seems to be the first completed run during this experiment
  M.ALLTHRES_MED = med_thres ;   
else  
  M.ALLTHRES_MED = [ M.ALLTHRES_MED; med_thres ];  % create column
end
if ~isfield(M, 'ALLTHRES_MEAN'),
  % hm, this seems to be the first completed run during this experiment
  M.ALLTHRES_MEAN = mean_thres ;   
else  
  M.ALLTHRES_MEAN = [ M.ALLTHRES_MEAN; mean_thres ];  % create column
end

% add this threshold's standard deviation (std.dev. of M_VAR during
% measurement phase of last run) to collection
if ~isfield(M, 'ALLTHRES_STD'),
  % hm, this seems to be the first completed run during this experiment
  M.ALLTHRES_STD = std_thres ;
else  
  M.ALLTHRES_STD = [ M.ALLTHRES_STD; std_thres ];  % create column
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
save(['psy_' M.SNAME], 'M', 'M_*')

% save once more with date/time string in filename:
dv=datevec(now);
m_filedate='_';
for k=1:3,
  m_filedate = [ m_filedate sprintf('%2.2d',mod(dv(k),100)) ];
end
save(['psy_' M.SNAME m_filedate ], 'M', 'M_*')


% 
if M.FEEDBACK,
  fprintf('  Result:  Parameter (%s): %g %s,\n', char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
  for k=2:M.NUM_PARAMS,
    fprintf('           Par.%d (%s): %g %s,\n', k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)));
  end  
  fprintf('           Threshold (%s) Mean: %g %s,  STD: %g %s \n\n', ...
	  M.VARNAME, mean_thres, M.VARUNIT, std_thres, M.VARUNIT);
end


% End of file:  mpsy_proto.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
