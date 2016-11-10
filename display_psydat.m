function [y_all, y_average, y_ave2, hplot] = display_psydat(s_name, exp_name, pstyle, param_perm) 

% analyse raw data in psydat-file, average them, and plot them
% ----------------------------------------------------------------------
% Usage: [y_all, y_average, y_ave2, hplot] = display_psydat(s_name, exp_name, pstyle, param_perm) 
%
%     Uses read_psydat to extract all data for subject s_name and
%     experiment exp_name.  Then sort and combine data into different
%     subgroups, one for each UNIQUE combination of values of M.PARAM(:).
%     Calculates the mean across threshold-data of different runs,
%     individually for each data subgroup. 
%
%     Output y_all and y_average are struct arrays, the length of both
%     being the number of unique values of the "higher parameter"
%     (par 2... par n) found in the data.
%     y_all and y_average both contain one struct-member psydata.
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
%       y_all  struct array containing ALL raw data belonging
%              to individual runs for s_name and exp_name.  The
%              index into y_all counts different unique sets of
%              values of the "higher" parameters, i.e. those
%              parameters that are not the 1st parameter (if any). 
%   y_average  similar struct array as y_all, but containing
%              the threshold data AVERAGED across all repetitions of
%              runs for identical sets of values of M.PARAM(:)
%      y_ave2  same data as y_average, but contained in one matrix,
%              where each final data point to be plotted is
%              contained in one line
%       hplot  array of handles to all plot lines
%
% Copyright (C) 2006  Martin Hansen , FH OOW

% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  12 Sep 2003

% Updated:  < 1 Jan 2007 14:59, hansen>
% Updated:  <22 Nov 2006 16:40, hansen>
% Updated:  <25 Okt 2006 19:01, hansen>
% Updated:  < 3 Feb 2006 10:46, hansen>
% Updated:  <20 Nov 2004 15:47, hansen>

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

% Determine the number of parameters of the current experiment.  
% Columns 1 to 4 contain median/sd/min/max of each threshold.
% Column 5 contains the 1st parameter, column 6 the 2nd parameter, etc.
npar     = size(y,2)-4;
if npar == 1,
  % hm... only 1 parameter.  Add one fake-column for par2, being
  % only zero.  this will then be the one-and-only value of par2,
  % thus yielding just 1 "unique" value, i.e. uni_par2==1, see below
  y = [y 0*y(:,end) ];
  % despite only 1 parameter, 'npar' must reflect size of matrix y
  npar = npar + 1;     
  param_perm = (1:npar);
end
par_cols = 5:size(y,2) ;      % the column indices of y containing the parameter(s)


% If no permutation was given as an argument, take the original order
% of parameters as default   
if nargin < 4,
  % take the regular order as found in the psydat file  
  param_perm = (1:npar);   
end
% apply the permutation of the parameters.  
y(:, 5:end) = y(:, 4+param_perm);


%% ---------- now an important step: ----------
%% here (i.e. only here) we specify which parameter columns of y are to  
%% be used in which order for the subsequent presentation of the data.
% the first parameter:  THIS one is going to appear on the x-axis 
par1 = y(:,5);      
% all further parameters: THESE are making up different data-curves' parameters
par2 = y(:,6:end);  

[uni_par2, uni_idx, rows_par2] = unique(par2, 'rows');

count = 0;    % count the final (averaged) data points for unique sets of parameter values

for k=1:length(uni_par2),     
  % select those row indices (into vector par1, matrix par2, and matrix y) 
  % which belong to the current unique set of further parameter values
  fidx = find(rows_par2 == k);
  % take that unique set of further parameters ...
  y_alltmp = y(fidx,:);
  % ... and sort matrix y_alltmp for ascending values of first parameter par1
  [par1sort,perm] = sort(par1(fidx));
  y_alltmp = y_alltmp(perm,:);
  % save sorted matrix y_alltmp into y_all(k),psydata
  y_all(k).psydata = y_alltmp;
  
  % for the current unique set of further parameters, find unique
  % values of first parameter
  uni_par1 = unique(par1(fidx));
  
  for l=1:length(uni_par1),
    % extract all data with same current first parameter
    y_avetmp = y_alltmp( find(par1sort == uni_par1(l)), :);
    % calculate mean across threshold values (each being a median),
    % and also the MEAN(!) across max und min values ...
    y_average(k).psydata(l,:) = mean(y_avetmp, 1);
    % ... but replace column 2 (containing individual std.dev. per run)
    % by the std.dev. across threshold values of different runs
    % (contained in column 1 of y, and also of y_alltmp, and y_avetmp) 
    y_average(k).psydata(l,2) = std(y_avetmp(:,1));

    % good! another data point has been compiled now.  save its data into 
    % matrix y_ave2 which will later be used for plotting with mpsy_plot_data.m
    count = count+1;
    y_ave2(count,:) = y_average(k).psydata(l,:);  
    
  end
end


%figure(200)
hplot=mpsy_plot_data(y_ave2(:,1), y_ave2(:,2), y_ave2(:,5:4+npar), pstyle);

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
title( strrep(tit,'_','\_') );



% End of file:  display_psydat.m

% Local Variables:
% time-stamp-pattern: "50/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
