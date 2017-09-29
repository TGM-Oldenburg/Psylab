% Usage: mpsy_proto_conststim()
% ----------------------------------------------------------------------
%          Protocols the results of the previous constant stimulus block run
%          Plots "PC" (percentage correct) as a function of M.VAR 
%          writes a corresponding result line into the "psydat"
%          file, in new psydat format version 2.
%          saves all variables M.* to disk
% 
%   input args:  (none) works on set of global variables M.* 
%  output args:  (none) processes subjects' answer and protocolls everything
%
% Copyright (C) 2016   Martin Hansen, Jade Hochschule
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  21 Okt 2016

% Updated:  <21 Okt 2016 15:15, mh>

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



% calculate estimated resulting "probablity correct" (value between 0 and 1, not 100!)
M.result_estim_probcorr = mean(M.CONSTSTIM_ALLANSWERS, 1);
% calculate std.error of prob_correct based on assumption of
% binomial distribution
M.result_stderr_probcorr = sqrt(M.result_estim_probcorr.*(1-M.result_estim_probcorr)/M.CONSTSTIM_NUM_PRESENTATIONS);

% Output all relevant information to a text protocol file
% this is done in the psydat format version 3 
%
% N.B. the order of the information in the following output DOES matter,
%       as read_psydat.m and psydat_helper.m rely on it. 
%
[fidm,message] = fopen( ['psydat_',M.SNAME], 'a' );


for ktmp = 1:length(M.CONSTSTIM_ALLVARS),
  
  fprintf(fidm,'##const## %s %s %s__%s npar %d ####\n', ...
          M.EXPNAME, M.SNAME, datestr(now,1), datestr(now,13), M.NUM_PARAMS);
  for k=1:M.NUM_PARAMS,
    fprintf(fidm,'%%%%----- PAR%d: %s %f %s\n', k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)));
  end  

  % output the information about the (non-)adaptive method used
  fprintf(fidm, '%%%%----- CONST: num_presentations %d \n', M.CONSTSTIM_NUM_PRESENTATIONS);
  
  % Output the mean of the correct answers, i.e. the relative occurence, as an
  % estimate of the probability of correct answers.  
  fprintf(fidm,'  %s %f %s   %s %f\n', ...
          M.VARNAME, M.CONSTSTIM_ALLVARS(ktmp), M.VARUNIT, 'prob_correct', M.result_estim_probcorr(ktmp));

end
 
fclose(fidm);



% ------------------------------------------------------------
% add new values pertaining to last run to the collection of data
% of all runs:  lowercase variable names are used to
% show that these do not contain user-specified values

% add this run's variable values to collection (of all runs)
if ~isfield(M, 'collect_allvars'),
  % hm, this seems to be the first completed run during this experiment
  M.collect_allvars = M.CONSTSTIM_ALLVARS ;   
else  
  % append a column
  M.collect_allvars = [ M.collect_allvars; M.CONSTSTIM_ALLVARS ];
end
% add this run's estimated prob_correct values to collection (of all runs)
if ~isfield(M, 'collect_estim_probcorr'),
  % hm, this seems to be the first completed run during this experiment
  M.collect_estim_probcorr = M.result_estim_probcorr ;   
else  
  % append a column 
  M.collect_estim_probcorr = [ M.collect_estim_probcorr; M.result_estim_probcorr ];
end
% add this run's std.err of prob_correct values to collection (of all runs)
if ~isfield(M, 'collect_stderr_probcorr'),
  % hm, this seems to be the first completed run during this experiment
  M.collect_stderr_probcorr = M.result_stderr_probcorr ;   
else  
  % append a column
  M.collect_stderr_probcorr = [ M.collect_stderr_probcorr; M.result_stderr_probcorr ];
end
% add the set of values of all parameters of the current run, as a
% row vector, to the collection (of all runs).  
if ~isfield(M, 'allparam'),
  % hm, this seems to be the first completed run during this experiment
  M.allparam = M.PARAM(:).';    % force a ROW shape
else
  % different values of the same parameter from different runs form
  % a column, so there will be M.NUM_PARAMS columns in M.ALLPARAM
  M.allparam  = [ M.allparam; M.PARAM(:).' ];  % append columns
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
  fprintf(' Results:  Parameter (%s): %g %s,\n', char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
  for k=2:M.NUM_PARAMS,
    fprintf('           Par.%d (%s): %g %s,\n', k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)));
  end  
  fprintf('           Variable %s (%s) \n', M.VARNAME, M.VARUNIT);
  fprintf('           Number of presentations N: %d \n', M.CONSTSTIM_NUM_PRESENTATIONS); 
  fprintf('           Var.         Prob.corr.    Pc. Std.error\n');
  fprintf('           ----------------------------------------\n');
  for k=1:length(M.CONSTSTIM_ALLVARS),
    fprintf('           %10g    %.4f        %.4f\n', ...
            M.CONSTSTIM_ALLVARS(k), M.result_estim_probcorr(k), M.result_stderr_probcorr(k));
  end
  fprintf('           ----------------------------------------\n');
end


% End of file:  mpsy_proto_conststim.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
