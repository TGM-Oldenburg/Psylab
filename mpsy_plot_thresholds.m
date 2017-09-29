% Usage: mpsy_plot_thresholds
% ----------------------------------------------------------------------
%     to be called at the end of mpsy_afc_main  or similar scripts
%
%     all data gathered in the previous adaptive experiment 
%     are plotted with threshold as a function of the parameter value(s)
%
% 
%   input:   (none), works on global variables
%  output:   (none), a plot figure
%
% Copyright (C) 2005  Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  30 Nov 2005
% Updated:  <25 Aug 2017 11:42, hansen>  file renamed from old name mpsy_plot_results.m
% Updated:  <30 Nov 2005 16:08, hansen>

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




if ~isfield(M, 'allthres_med'),
  warning('no threshold data seem to have been gathered so far');
  return
end

figure(200)
h = mpsy_plot_data(M.allthres_med, M.allthres_std, M.allparam, M.RESULTSTYLE);

xl = [char(M.PARAMNAME(1)) ' [' char(M.PARAMUNIT(1)) ']'];
xlabel(strrep(xl, '_',' '));

yl = [M.VARNAME ' [' M.VARUNIT ']'];
ylabel(strrep(yl, '_',' '));


tit = ['Exp. ' M.EXPNAME ];
if M.NUM_PARAMS>1,
  for l=2:M.NUM_PARAMS,
    tit = [tit sprintf(',  Par.%d: %s [%s]', l, char(M.PARAMNAME(l)), char(M.PARAMUNIT(l))) ];
  end
end
title(strrep(tit,'_','\_'));

if M.FEEDBACK>1,
  print('-dpsc','-append', ['plot_thres_' M.SNAME])
end


% End of file:  mpsy_plot_thresholds.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
