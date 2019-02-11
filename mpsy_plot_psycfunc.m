% Usage: mpsy_plot_psycfunc
% ----------------------------------------------------------------------
%     to be called at the end of mpsy_afc_main  or similar scripts
%
%     all data gathered in the previous constant stimulus experiment 
%     are plotted in the shape of psychometric function(s)
%
% 
%   input:   (none), works on global variables
%  output:   (none), a plot figure
%
% Copyright (C) 2017  Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  25 Aug 2017
% Updated:  <25 Aug 2017 13:09, martin>


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




if ~isfield(M, 'collect_stderr_probcorr'),
  warning('no threshold data seem to have been gathered so far');
  return
end

% rearrange the data into a shape that is suitable for plotting 
% with mpsy_plot_data: 
clear tmp
% simple reshaping of M.collect_estim_probcorr and M.collect_stderr_probcorr, 
% such that each line contains 1 data point
xtmp = M.collect_estim_probcorr';  tmp.collect_estim_probcorr  = xtmp(:);
xtmp = M.collect_stderr_probcorr'; tmp.collect_stderr_probcorr = xtmp(:);
% and generate matrix tmp.allparam:  
%  1st column contains the values of M.VAR
%  2nd-last column contain the values of M.PARAM(1) through  M.PARAM(end)
[npars,nvars] = size(M.collect_allvars);
for kk=1:npars,
  for ll=1:nvars,
    idxtmp = (kk-1)*nvars + ll;
    tmp.allparam(idxtmp,:) = [M.collect_allvars(kk,ll)  M.allparam(kk,:)];
  end
end
  

figure(200)
% Factor 100 just gives probabilities in percent. 
hplot = mpsy_plot_data(100*tmp.collect_estim_probcorr, 100*tmp.collect_stderr_probcorr, tmp.allparam, M.RESULTSTYLE);

xl = [M.VARNAME ' [' M.VARUNIT ']'];
xlabel(strrep(xl, '_',' '));

ylabel('percent correct');

tit = ['Exp. ' M.EXPNAME ];
if M.NUM_PARAMS>1,
  for l=1:M.NUM_PARAMS,
    tit = [tit sprintf(',  Par.%d: %s [%s]', l, char(M.PARAMNAME(l)), char(M.PARAMUNIT(l))) ];
  end
end
title(strrep(tit,'_','\_'));

% Now correct the legend text: compared to the legend output of mpsy_plot_data
% for an adaptive experiment, all parameter numbers have reduced by 1.
% Not elegant, but we do this by literal text replacement:
for kk=1:length(hplot),
  tmpname = get(hplot(kk), 'DisplayName');               % get wrong label text 
  tmp_idx_occur = regexp(tmpname, 'par.=');              % find all occurences
  for ll=1:length(tmp_idx_occur),
    tmp_param_char = tmpname(tmp_idx_occur(ll)+3);       % wrong param number
    tmp_param_char = num2str(str2num(tmp_param_char)-1); % subtract 1
    tmpname(tmp_idx_occur(ll)+3) = tmp_param_char  ;     % replace by new number 
  end
  set(hplot(kk), 'DisplayName', tmpname);                % reassign legend text
  
end



if M.FEEDBACK>1,
  print('-dpsc','-append', ['plot_psycfunc_' M.SNAME])
end


% End of file:  mpsy_plot_psycfunc.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
