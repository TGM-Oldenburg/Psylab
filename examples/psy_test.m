% Usage: y = psy_test()
%
%   input:   ---------
%  output:   ---------
%
% Copyright (C) 2005 by Martin Hansen, Fachhochschule OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  26 Jun 2005
% Updated:  <>

%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl


%ex = char(questdlg('Welches Experiment wollen Sie durchführen?', ...
%                   'Sommerfest FH OOW, JND-Messung -- © M.Hansen', ...
%		    'intensity', 'frequency', 'intensity'));


clear mean_thres
% do the experiment
eval(['jnd_' ex])

fname = ['vp_data_' M_EXPNAME];

if exist('mean_thres'),
  load(fname)

  % append new data to vector of old ones
  vp_names = [vp_names cellstr(M_SNAME)];
  vp_thres_meds = [vp_thres_meds med_thres];
  vp_thres_means = [vp_thres_means mean_thres];
  vp_thres_sds = [vp_thres_sds std_thres];
  save(fname, 'vp_*')
  
  % save once more with date-tag in name
  dv=datevec(now);
  m_filedate='_';
  for k=2:5,
    m_filedate = [ m_filedate sprintf('%2.2d',mod(dv(k),100)) ];
  end
  save([fname m_filedate], 'vp_*')
  
  
  %figure(113)
  f_ax = findobj('Tag', 'psy_gui_axes')
  axes(f_ax);
  errorbar(vp_thres_meds, vp_thres_sds, 'b');
  hold on
  errorbar(numel(vp_thres_meds), vp_thres_meds(end), vp_thres_sds(end), 'ro');
  hold off
  text(length(vp_thres_meds)+0.2, vp_thres_meds(end), M_SNAME);
  xlabel('Versuchsperson')
  ylabel('Schwellenwert (Median/Std.)');
end



% End of file:  psy_test.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
