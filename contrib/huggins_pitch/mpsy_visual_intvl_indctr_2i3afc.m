% ----------------------------------------------------------------------
%    to be called from mpsy_present
%
%   input:   (none), depends on global variables
%  output:   (none), changing color of buttons on response GUI
%
% This file is based on mpsy_visual_interval_indicator  by Martin Hansen.
% Now gives visual indication with 2-interval 3-afc procedures.
% 
% Copyright (C) 2007 Georg Stiefenhofer.
% Author :  Georg Stiefenhofer.




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



% the duration of one stimulus interval.  For this script to work, it
% is REQUIRED that both reference signal and test signal have the same
% duration
dur_interval1 = size(m_test1,1)/M.FS;     
dur_interval2 = size(m_test2,1)/M.FS;    
if exist('m_ref','var'),
  dur_ref = size(m_ref,1)/M.FS;     
  if dur_ref ~= dur_interval1 || dur_ref ~= dur_interval2
    fprintf('*** reference signal m_ref and test signal m_test have different lengths.\n');
    fprintf('*** In this case the visual interval indication cannot work\n');
    warning('setting M_VISUAL_INDICATOR to 0');
    M.VISUAL_INDICATOR = 0;
  end
else
  dur_ref1 = size(m_ref1,1)/M.FS;     
  dur_ref2 = size(m_ref2,1)/M.FS;     
  if dur_ref1 ~= dur_interval | dur_ref1 ~= dur_ref2, 
    fprintf('*** your reference signals m_ref1 and m_ref2 and test signal m_test have different length\n');
    fprintf('*** in this case the visual interval indication cannot work\n');
    warning('setting M_VISUAL_INDICATOR to 0');
    M.VISUAL_INDICATOR = 0;
  end
end
 
dur_presig   = size(m_presig,1)/M.FS;  % duration of pre-signal
dur_postsig  = size(m_postsig,1)/M.FS; % duration of post-signal
dur_quiet    = size(m_quiet,1)/M.FS;   % dur. of quiet pause between intervals


%c_tmp = get(afc_b1, 'BackgroundColor');   % store the normal color
c_tmp = 0.8*[1 1 1];

pause(dur_presig);

set(afc_i1, 'BackgroundColor', [1 0 0]);  % RED
pause(dur_ref);
set(afc_i1, 'BackgroundColor', c_tmp);    % back to normal

pause(dur_quiet);

set(afc_i2, 'BackgroundColor', [1 0 0]);  % RED
pause(dur_interval1);
set(afc_i2, 'BackgroundColor', c_tmp);    % back to normal

pause(dur_postsig);

  
