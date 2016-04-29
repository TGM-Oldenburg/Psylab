function h = mpsy_plot_data(thres, sd, par, pstyle)

% Usage: h = mpsy_plot_data(thres, sd, par, pstyle)
% ----------------------------------------------------------------------
%
% make errorbar plot of threshold data in 'thres' and standard
% deviations in 'sd' as a function of 1st parameter (1st column in
% 'par'), using one line per unique value of further parameters
% (column 2, 3, ..., if any) in 'par'
% 
%   input:   
%    thres   vector of threshold data
%    sd      vector of threshold standard deviations, must have
%                   same size as thres 
%    par     matrix of parameter(s) data, must have 
%                   same number of rows as length(thres)
%    pstyle  [optional] plotstyle:  
%                1 == all data into one figure  (default)
%                2 == one figure per unique set of values of >=3rd paramters
%
%  output:   
%     h      handle to errorbar plot
%
% Copyright (C) 2005  Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  30 Nov 2005

% Updated:  < 4 Feb 2007 16:48, hansen>
% Updated:  <22 Nov 2006 16:40, hansen>
% Updated:  <25 Okt 2006 19:44, hansen>
% Updated:  <20 Okt 2006 14:14, hansen>
% Updated:  < 6 Feb 2006 23:34, mh>
% Updated:  < 8 Jan 2006 10:28, mh>

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


if nargin < 4,
  pstyle = 1;
end

  
  
if min(size(thres))>1 | min(size(sd))>1  ,
  error('arguments thres and sd must be 1-dim vectors');
end

if (length(thres) ~= length(sd)) | (length(thres) ~= size(par,1)) 
  error('arguments must be of identical length/number of rows');
end


% pfor lotting: a pool of Symbols and Colors
pls={'o:';'s:';'d:';'v:';'^:';'<:';'>:';'p:';'h:';'*:';'+:';'x:';'o:';'s:';'d:';'v:';'^:';'<:';'>:'};
% pls={'o';'s';'d';'v';'^';'<';'>';'p';'h';'*';'+';'x';'.'};
plc=0.25* [0 0 4;0 4 0;4 0 0;0 3 3;3 0 3;3 3 0; 2 2 2;0 0 2;0 2 0;2 0 0;0 3 1;0 1 3;3 0 1;1 0 3;3 1 0;1 3 0];


%% ---------- make the plots
% plot one errorbar-line for each unique set of values of further parameters
npar = size(par,2);    % number of parameters
par1 = par(:,1);       % the first parameter
par2 = par(:,2:npar);  % all further parameters
[uni_par2, uni_idx, rows_par2] = unique(par2, 'rows');

if npar == 1,
  uni_par2 = 1;
  pstyle = -1;   % special (most easy) case, see below
end

while length(uni_par2) > min(length(plc), length(pls)),
  plc = [plc; plc];  % add more colours by repetition
  pls = [pls; pls];  % add more symbols by repetition
end

  
switch pstyle
 case -1,      % special case when only one parameter is present
    % there was nothing special to do.  just plot all the data...
    h = errorbar(par1, thres, sd, char(pls(1)));
 case 1,       % all data into one figure
   for k=1:size(uni_par2,1),
     % select row indices to unique further parameter value sets
     fidx = find(rows_par2 == k);
     h(:,k) = errorbar(par1(fidx), thres(fidx), sd(fidx), char(pls(k)));
     set(h(:,k), 'Color', plc(k,:));
     hold on;
   end
   hold off;
   
 case 2,      % unique figure for unique set of values of further parameters
   for k=1:length(uni_idx),
     figure(200+k);
     fidx = find(rows_par2 == k);
     h(:,k) = errorbar(par1(fidx), thres(fidx), sd(fidx), char(pls(k)));
     %set(h(:,k), 'Color', plc(k,:));
   end
   
 otherwise,
   error('wrong number for argument pstyle');
end
  

%% ---------- make the legends
% if more than only one (i.e. more than the first) parameter
% exists, create legend(s), in case that more than one parameter
% value set of further parameters exists  
if (npar > 1) & (length(uni_par2)>1),
  for k=1:length(uni_idx),
    % create legend for the k'th data set 
    htmp = [];
    for l=2:npar,
      htmp = [htmp sprintf('par%d=%g  ', l, par(uni_idx(k), l)) ];
    end
    
    % save each legend into cellstring array, necessary for pstyle==1
    leg(k) = {htmp};
    
    if pstyle == 2,
      % apply the (only-one-line) legend directly into the figure
      
      % Now something UGLY:  Matlab has stupidly changed the way how handles
      % are assigned to errorbar-plots between its versions 6 and 7.  ARGH!!
      if strcmp( version('-release'), '13'),
        %% again STUPID:  Matlab changed the possible location arguments in 2016a
	%% legend(h(2,k), leg(k), 0);  
        legend(h(2,k), leg(k), 'location', 'Best');  
      else
	%%legend(h(k), leg(k), 0);  
        legend(h(k), leg(k), 'location', 'Best');  
      end
    end
    
  end
  if pstyle == 1,
    % Now something UGLY:  Matlab has stupidly changed the way how handles
    % are assigned to errorbar-plots between its versions 6 and 7.  ARGH!!
    if strcmp( version('-release'), '13'),
      %% again STUPID:  Matlab changed the possible location arguments in 2016a
      %%legend(h(2,:), leg, 0);   % set all legend lines at once
      legend(h(2,:), leg, 'location', 'Best');   % set all legend lines at once
    else
      %%legend(h, leg, 0);   % set all legend lines at once
      legend(h, leg, 'location', 'Best');   % set all legend lines at once
    end
    
  end
  
end


% finally, do NOT create xlabel, ylabel, and title but instead let the
% calling script perform this



% End of file:  mpsy_plot_data.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
