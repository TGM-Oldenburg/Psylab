function h = mpsy_replot_run(subject_name, exp_name, run_idx)

% Usage: h = mpsy_replot_run(subject_name, exp_name, run_idx)
% ----------------------------------------------------------------------
%     will be called from psydat_helper.  Replots one experimental run
% 
%   input:   
%     subject_name    name of subject, as would be used for read_psydat
%     exp_name        name of experiment, as would be used for read_psydat
%     run_idx         number of experimental run of that subject
%                     and experiment within the corresponding psydat-file
%
%  output:   
%      h           handle of the resulting plot, showing the
%                  progress of M.VAR and the subject's answer as
%                  also done by mpsy_plot_feedback.m 
%
% Copyright (C) 2015   Martin Hansen/Stephanus Volke, Jade Hochschule
% Author :  Martin Hansen/Stephanus Volke,  <psylab AT jade-hs.de>
% Date   :  27 Jun 2003
% Updated:  <29 Apr 2016 16:19, mh>
% Updated:  <21 Jul 2015 16:34, mh>
% Updated:  <14 Jan 2014 11:30, mh / Stephanus Volke >

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


x = read_psydat(subject_name, exp_name);

figure(111);

if isfield(x, 'run'),
  idx_plus  = find(x.run(run_idx).answers ==1);  % correct/down answers
  idx_minus = find(x.run(run_idx).answers ==0);  % wrong/up answers
end

if ~isfield(x, 'run') | isempty(idx_plus) | isempty(idx_minus),
  clf;
  msg = sprintf('there are apparently no trial-data saved for run #%d of subject "%s" \nand experiment "%s" in the psydat-file\n', ...
        run_idx, subject_name, exp_name);
  % just an empty plot
  plot([0 1 0 1 0], [0 1 1 0 0], 'r:');  % plot a visual cross 
  text(0.05, 0.2, strrep(msg, '_', '\_'));
  fprintf(msg);
  
else

  % simple plot
  vars = x.run(run_idx).vars;
  h=plot(1:length(vars), vars,'b.-', idx_plus, vars(idx_plus), 'r+', idx_minus, vars(idx_minus), 'ro');

  xlabel('trial number')
  yl = [ char(x.varname(run_idx)) ' [' char(x.varunit(run_idx)) ']'];
  ylabel(strrep(yl, '_','\_'));
  
  % add text information about median and std.dev., 
  text(0.6*length(vars), 0.7*max(x.run(run_idx).vars)+0.3*min(x.run(run_idx).vars),sprintf('thresh:%g, std:%g', x.threshold(run_idx), x.thres_sd(run_idx)));

end

titl = ['Exp.: ' exp_name ', Parameter: ' char(x.par(1).name(run_idx)) ' = ' num2str(x.par(1).value(run_idx)) ' ' char(x.par(1).unit(run_idx))];

for k=2:length(x.par),
  titl = [titl '  Par.' num2str(k) ': ' char(x.par(k).name(run_idx)) ' = ' num2str(x.par(k).value(run_idx)) ' ' char(x.par(k).unit(run_idx))];
end
title(strrep(titl,'_','\_'));

% add a legend with subject name and date
leg = sprintf('%s: %s', subject_name, char(x.date(run_idx)));
legend(strrep(leg, '_', '\_'), 'location', 'Best' );
  

% End of file:  mpsy_replot_run.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
