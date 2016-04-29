% Usage: mpsy_plot_feedback
% ----------------------------------------------------------------------
%     to be called from mpsy_afc_main  or similar scripts
% 
%   input:   (none), works on global variables
%  output:   (none), a plot figure
%
% Copyright (C) 2003, 2004   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  27 Jun 2003
% Updated:  <14 Jan 2004 11:30, hansen>

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


%figure(111);
idx_plus  = find(M.ANSWERS ==1);  % correct answers
idx_minus = find(M.ANSWERS ==0);  % wrong answers

% in case that threshold has not yet been reached, a preliminary
% plot is shown.  Otherwise the plot is Whether threshold has been
% reached, can be checked by the content of M.med_thres, which is
% only set via mpsy_proto
if isempty(M.med_thres),
  % simple plot
  plot(1:length(M.VARS), M.VARS,'b.-', idx_plus, M.VARS(idx_plus), 'r+', idx_minus, M.VARS(idx_minus), 'ro');
else
  % a somewhat nicer plot.  
  % Careful:  The field M.familiarization_fidx has been calculated by mpsy_proto.  
  % The 2 indices at transition between familiarization phase and measurement phase: 
  idx_trans = [M.familiarization_fidx(end) M.measurement_fidx(1)]; %
  hp = plot(M.measurement_fidx, M.VARS(M.measurement_fidx), 'k.-', ...
            M.familiarization_fidx, M.VARS(M.familiarization_fidx), 'k.-', ...
            idx_trans, M.VARS(idx_trans), 'k--', ...
            idx_plus, M.VARS(idx_plus), 'r+', ...
            idx_minus, M.VARS(idx_minus), 'ro');
  set(hp([2 3]), 'Color', 0.5*[1 1 1]);
end

xlabel('trial number')
yl = [ M.VARNAME ' [' M.VARUNIT ']'];
ylabel(strrep(yl, '_','\_'));

tit = ['Exp.: ' M.EXPNAME ', Parameter: ' char(M.PARAMNAME(1)) ' = ' num2str(M.PARAM(1)) ' ' char(M.PARAMUNIT(1))];

for k=2:M.NUM_PARAMS,
  tit = [tit '  Par.' num2str(k) ': ' char(M.PARAMNAME(k)) ' = ' num2str(M.PARAM(k)) ' ' char(M.PARAMUNIT(k))];
end
title(strrep(tit,'_','\_'));

% add a legend with subject name and date
legend( sprintf('%s: %s',M.SNAME,datestr(now)), 0 );

% and add text information about median and std.dev., 
% but only if run is finished, i.e. threshold is reached.  This can
% be checked via the variable M.med_thres that is set to a value
% only after a call to mpsy_proto 
if ~isempty(M.med_thres),
  text(M.measurement_fidx(1), 0.5*(M.VARS(M.measurement_fidx(1))+max(M.VARS)), ...
     sprintf('med:%g, mean:%g, std:%g ', M.med_thres, M.mean_thres, M.std_thres));
end

% save the plot figure containing all M.VARS of current run into eps-file
if M.DEBUG>3 | M.FEEDBACK>1,
  m_plotfilename = ['plot_run_' M.SNAME];
  
  if M.FEEDBACK>2,
    % add date and time information to plot-filename
    tmp = datestr(now, 30);
    tmp = tmp(3:end-2); tmp(7)='-';
    m_plotfilename = [m_plotfilename tmp '_'];
  end
  
  print('-dpsc','-append', m_plotfilename)
end


% End of file:  mpsy_plot_feedback.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
