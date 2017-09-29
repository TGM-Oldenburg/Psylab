function [x, y] = display_psydat_raw(s_name, exp_name, pstyle, param_perm) 

% analyse raw data in psydat-file and plot them
% ----------------------------------------------------------------------
% Usage: [x, y] = display_psydat_raw(s_name, exp_name, pstyle, param_perm) 
%
%     Use read_psydat to extract all data for subject s_name and
%     experiment exp_name.  Then use mpsy_plot_data to plot all the
%     raw threshold data.
%
%   input:   ---------
%      s_name  subject name (as found in data file)
%    exp_name  experiment name (as found in data file)
%      pstyle  plot style  [optional, default = 1]: 
%                 1 = plot all data into 1 figure
%                 2 = make 1 figure per each unique value of higher
%              parameters (parameter number > 2)
% param_perm   parameter permutation [optional, default: [1 2 3 ...]]
%                 allows to permutate the parameter numbers
%
%  output:   ---------
%       x   struct variable containing all data belonging t s_name and exp_name
%       y   same data as x, but numeric data only, and in matrix format
%
% Copyright (C) 2004 by Martin Hansen, Fachhochschule OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  15 Jan 2004
% Updated:  <24 Mai 2017 16:09, martin>
% Updated:  <15 Jan 2009 16:11, hansen>
% Updated:  < 3 Feb 2006 10:52, mh>
% Updated:  <24 Nov 2004 08:58, hansen>

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

if nargin < 2, help(mfilename); return; end;

if nargin < 3,
  pstyle = 1;  % default value
end


% extract data from psydat file
[x, y] = read_psydat(s_name, exp_name);

% Determine the number of parameters of the current experiment:  
if isfield(x, 'adapt_method'),
  % In an adaptive experiment, columns 1 to 4 of the output y from
  % read_psydat contain median/sd/min/max of each threshold. 
  % Column 5 contains the 1st parameter, column 6 the 2nd parameter, etc.
  col_idx_1st_param = 5;   % column number of the 1st parameter
  
  % NOTE: The result plot will show threshold (of the variable
  % M.VAR) as a function of parameter1, with separate curves for
  % any combination of values of 2nd, 3rd ... parameter.   
  % The role of 1st, 2nd, etc. parameter may be permutated, thus
  % possibly leading to different x-axes.  

elseif isfield(x, 'num_presentations'),
  % In a constant stimulus experiment, column 1 and 2 of the output y from
  % read_psydat contain the prob_correct and the num_presentations.
  % Column 3 contains the value of the variable. 
  % Column 4 contains the 1st parameter, column 5 the 2nd parameter, etc.
  col_idx_1st_param = 4;   % column number of the 1st parameter
  col_idx_var       = 3;

  % NOTE: The result plot will show percent-correct as a
  % function of the stimulus variable (M.VAR) with separate
  % curves for any combination of values of 1st, 2nd, 3rd ... parameter.  
  % The role of 1st, 2nd, etc. parameter could be permutated, but that
  % does not make much sense.  Contrary to the adaptive method, the x-
  % and y-axes will always remain to be variable and percent-correct. 

else
  error('unknown type of experiment data were read from psydat file');

end
  
% alternative expression for the following line:
% npar= size(y,2)-4 (for adapt.)  resp. npar=size(y,2)-3 (for const.stim.)
npar = size(y,2) - col_idx_1st_param + 1;  
 

if isfield(x, 'adapt_method') & npar == 1,
  % hm... only 1 parameter.  Add one fake-column for par2, being
  % only zero.  this will then be the one-and-only value of par2,
  % thus yielding just 1 "unique" value, i.e. uni_par2==1, see below
  y = [y 0*y(:,end) ];
  % despite only 1 parameter, 'npar' must reflect size of matrix y
  npar = npar + 1;     
  param_perm = (1:npar);
end

%par_cols = col_idx_1st_param:size(y,2) ;      % the column indices of y containing the parameter(s)


% If no permutation was given as an argument, take the original order
% of parameters as default   
if nargin < 4,
  % take the regular order as found in the psydat file  
  param_perm = (1:npar);   
else
  % 4th argument is the permutation order for the parameters
  if isfield(x, 'num_presentations'),
    warning('You chose a parameter permuation for a const.stim. exeriment.  Although possible, you might rethink its necessity');
  end
  
end
% apply the permutation of the parameters.  
y(:, col_idx_1st_param:end) = y(:, (col_idx_1st_param-1)+param_perm);


% ----------------------------------------------------------------------
% now the step of specifying  which parameter columns of y are to  
% be used in which order for the subsequent presentation of the data
% ----------------------------------------------------------------------
if isfield(x, 'adapt_method'),
  % first parameter: THIS one is going to appear on the x-axis
  % %% par1 = y(:,col_idx_1st_param);      
  % all further parameters: THESE are making up different data-curves' parameters
  par2 = y(:,col_idx_1st_param+1:end);  

  uni_par2 = unique(par2, 'rows');

  mpsy_plot_data(y(:,1), y(:,2), y(:,5:4+npar), pstyle);

  yl = [char(x.varname(1)) ' [' char(x.varunit(1)) ']'];
  ylabel(strrep(yl, '_',' '));

  xl = [char(x.par(param_perm(1)).name(1)) ' [' char(x.par(param_perm(1)).unit(1)) ']'];
  xlabel(strrep(xl, '_',' '));

  tit = sprintf('experiment %s, subject %s', exp_name, s_name);
  % only mention the further parameters in the title, if at least 2
  % different values of par2 are found in the current data:
  if length(uni_par2) > 1,
    for l=2:npar,
      tit = [tit sprintf(',  Par.%d: %s [%s]', l, ...
		         char(x.par(param_perm(l)).name(1)), ...
		         char(x.par(param_perm(l)).unit(1))) ];
    end	 
  end
  
% --------------------------------------------------------------------------------
elseif isfield(x, 'num_presentations'),
  % The variable:  THIS one is going to appear on the x-axis 
  % %% var1 = y(:,col_idx_var);      
  % and all parameters: THESE are making up different data-curves' parameters
  % %% par2 = y(:,col_idx_1st_param:end);  

  % %% uni_par2 = unique(par2, 'rows');
  
  % replace column 2 in y, holding the number of repitions, by the
  % associated estimated standard error (see display_psydat.m for
  % an explanation.
  fprintf('*** info:  %s: meaning of the 2nd column of 2nd output changed from \n', mfilename)
  fprintf('           "number of presentations" to "estimated standard error of prob_correct"\n')
  y(:,2) = sqrt( y(:,1).*(1-y(:,1))./y(:,2) );
  % also reflect this change in struct x:  
  x.std_err_prob_correct = y(:,2)';
  % and remove the precious field 
  x = rmfield(x, 'num_presentations');
  
  mpsy_plot_data(100*y(:,1), 100*y(:,2), y(:,3:end), pstyle);

  xl = [char(x.varname(1)) ' [' char(x.varunit(1)) ']'];
  xlabel(strrep(xl, '_',' '));

  ylabel('percent correct');

  tit = sprintf('experiment %s, subject %s', exp_name, s_name);
  for l=1:npar,
    tit = [tit sprintf(',  Par.%d: %s [%s]', l, ...
                       char(x.par(param_perm(l)).name(1)), ...
                       char(x.par(param_perm(l)).unit(1))) ];
  end
  
% --------------------------------------------------------------------------------
end

title( strrep(tit,'_','\_') );


% End of file:  display_psydat_raw.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
