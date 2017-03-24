function mpsy_info(flag_use_gui, h1, text1, h2, text2)

% Usage: mpsy_info(flag_use_gui, h1, text1, h2, text2)
% ----------------------------------------------------------------------
%
%   input:   ---------
%     flag_use_gui     flag whether output into GUI (1) or on screen (0)
%               h1     handle to first text field inside GUI
%            text1     text to be placed there (or on screen)
%               h2     [optional] handle to 2nd text field inside GUI
%            text2     [optional] text to be placed there (or on screen)
%
%  output:   ---------
%     (none)
%
% Copyright (C) 2006 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  25 Okt 2006
% Updated:  < 1 Nov 2006 16:01, hansen>

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


if nargin >= 3,
  if flag_use_gui & ishandle(h1),
    set(h1, 'String', text1);
  else
    if ~isempty(text1),
      fprintf('\n%s\n\n', text1);
    end
  end
end

if nargin == 5
  if flag_use_gui & ishandle(h2),
    set(h2, 'String', text2);
  else
    if ~isempty(text2),
      fprintf('\n%s\n\n', text2);
    end
  end
end



% End of file:  mpsy_info.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
