function y = mpsy_split_lines_to_toks(line_string) 

% Usage: mpsy_split_lines_to_toks()
% ----------------------------------------------------------------------
%   take one line of text string and return it split up into space
%   separated words, separately placed in columns of cellstring y 
% 
%   input:   ---------
%      line_string   character string   (see above)
%  output:   ---------
%      y             cellstring array   (see above)
%
% Copyright (C) 2003, 2004   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  10 Sep 2003
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


tok = {};  % to avoid crash in case of empty input
idx = 1;
[t,r] = strtok(line_string);
while ~ isempty(r),
  tok(idx) = cellstr(t);
  idx = idx + 1;
  [t,r] = strtok(r);
end

% falls der letzte tok mit space anfaengt aber mit newline aufhoert:
if ~isempty(t),
  tok(idx) = cellstr(t);
end

y = tok;

% End of file:  mpsy_split_lines_to_toks.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
