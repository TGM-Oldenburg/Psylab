% Usage: mpsy_proto_conststim()
% ----------------------------------------------------------------------
%          Protocols the results of the previous constant stimulus block run
%          Plots "PC" (percentage correct) as a function of M.VAR, 
%          writes a corresponding result line into the "psydat"
%          file, in psydat format version 3.
%          In case M.DEBUG > 0,  all variables M.* are saved in a
%          separate mat-file which can be useful for debugging
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


% calculate estimated resulting "probablity correct" 
% (this is a value between 0 and 1, not 100!) 
M.result_estim_probcorr = mean(M.CONSTSTIM_ALLANSWERS, 1);
% calculate std.error of prob_correct based on assumption of
% binomial distribution
M.result_stderr_probcorr = sqrt(M.result_estim_probcorr.*(1-M.result_estim_probcorr)/M.CONSTSTIM_NUM_PRESENTATIONS);

% Now output all relevant information to a text protocol file
% this is done in the psydat format version 3 
%
% N.B. the order of the information in the following output DOES matter,
%       as read_psydat.m and psydat_helper.m rely on it. 
%
[fidm,message] = fopen( ['psydat_',M.SNAME], 'a' );


% to avoid that the second changes during the foll
tmp_date = datestr(now,1);
tmp_time = datestr(now,13);

for ktmp = 1:length(M.CONSTSTIM_ALLVARS),
  
  fprintf(fidm,'##const## %s %s %s__%s npar %d ####\n', ...
          M.EXPNAME, M.SNAME, tmp_date, tmp_time, M.NUM_PARAMS);
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

% if flag-variable M.SAVERUN has been set accordingly, output the
% individual values of M.VAR and the answers to the psydat file.  Here,
% the data are output at the end of a block of const-stim data points
if (isfield(M, 'SAVERUN')) & M.SAVERUN == 1
  fprintf(fidm, '%%%%----- VAL:');
  for k = 1:length(M.ANSWERS)
    fprintf(fidm, ' %g %d', M.VARS(k), M.ANSWERS(k));
  end
  fprintf(fidm, '\n');
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
  % append a row
  M.collect_allvars = [ M.collect_allvars; M.CONSTSTIM_ALLVARS ];
end
% add this run's estimated prob_correct values to collection (of all runs)
if ~isfield(M, 'collect_estim_probcorr'),
  % hm, this seems to be the first completed run during this experiment
  M.collect_estim_probcorr = M.result_estim_probcorr ;   
else  
  % append a row 
  M.collect_estim_probcorr = [ M.collect_estim_probcorr; M.result_estim_probcorr ];
end
% add this run's std.err of prob_correct values to collection (of all runs)
if ~isfield(M, 'collect_stderr_probcorr'),
  % hm, this seems to be the first completed run during this experiment
  M.collect_stderr_probcorr = M.result_stderr_probcorr ;   
else  
  % append a row
  M.collect_stderr_probcorr = [ M.collect_stderr_probcorr; M.result_stderr_probcorr ];
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
  mpsy_proto_debuginfo;
end

% 
if M.FEEDBACK,
  fprintf(' Results:  Parameter (%s): %g %s,\n', ...
           char(M.PARAMNAME(1)), M.PARAM(1), char(M.PARAMUNIT(1)));
  for k=2:M.NUM_PARAMS,
    fprintf('           Param.%d   (%s): %g %s,\n', ...
             k, char(M.PARAMNAME(k)), M.PARAM(k), char(M.PARAMUNIT(k)));
  end  
  fprintf('           Variable: %s (%s) \n', M.VARNAME, M.VARUNIT);
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
