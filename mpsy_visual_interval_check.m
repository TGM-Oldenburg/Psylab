% Usage: mpsy_visual_interval_check
% ----------------------------------------------------------------------
%    to be called from mpsy_visual_interval_indicator or mpsy_msound_present
%
%   input:   (none), depends on global variables
%  output:   (none), changing color of buttons on response GUI
%
% Copyright (C) 2011 by Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  01 Nov 2011
% Updated:  < 1 Nov 2011 10:05, martin>

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



% For the visual interval indication scripts to work, it is REQUIRED
% that both reference signal and test signal have the same duration

% however, we only need to check this when M.VISUAL_INDICATOR != 0
if M.VISUAL_INDICATOR, 
  
  % the duration of one stimulus interval:
  dur_interval = size(m_test,1)/M.FS;     
  if exist('m_ref'),
    dur_ref = size(m_ref,1)/M.FS;     
    if dur_ref ~= dur_interval, 
      fprintf('*** reference signal m_ref and test signal m_test have different lengths.\n');
      fprintf('*** In this case the visual interval indication cannot work\n');
      warning('setting M_VISUAL_INDICATOR to 0');
      M.VISUAL_INDICATOR = 0;
    end
  else
    dur_ref1 = size(m_ref1,1)/M.FS;     
    dur_ref2 = size(m_ref2,1)/M.FS;     
    if dur_ref1 ~= dur_interval | dur_ref1 ~= dur_ref2, 
      fprintf('*** your reference signals m_ref1 and m_ref2 and test signal m_test have different lengths.\n');
      fprintf('*** in this case the visual interval indication cannot work\n');
      warning('setting M_VISUAL_INDICATOR to 0');
      M.VISUAL_INDICATOR = 0;
    end
  end
  
end

% End of file:  mpsy_visual_interval_check.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
