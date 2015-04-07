function y = psydat_helper_probe() 



%
% ----------------------------------------------------------------------
% Usage: y = psydat_helper2()
%
%   input:   ---------
%  output:   ---------
%
% Copyright (C) 2009 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  23 Feb 2009
% Updated:  <>

%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

%if nargin < 1, help(mfilename); return; end;




psydat_filename = ['psydat_' s_name];

psylines = textread('psydat_mh', '%s',  'whitespace', '\n');

% find occurrences
exp_line_idx = strmatch ('#### ', psylines);

clear exp_name;

for k=1:length(exp_line_idx),
  psylines(exp_line_idx(k));
  tok = mpsy_split_lines_to_toks(char(psylines(exp_line_idx(k))));
  exp_name(k) = tok(2);
  exp_datetime = char(tok(4));

% $$$   exp_date{k} = cellstr(exp_datetime(1:11));
% $$$   exp_time{k} = cellstr(exp_datetime(14:end));
  
% $$$   exp_date(k,:) = exp_datetime(1:11);
% $$$   exp_time(k,:) = exp_datetime(14:end);

% $$$   exp(k).date = exp_datetime(1:11);
% $$$   exp(k).year = exp_datetime(8:11);
% $$$   exp(k).month = exp_datetime(4:6);
% $$$   exp(k).time = exp_datetime(14:end);
% $$$   exp(k).hour = exp_datetime(14:15);
% $$$   exp(k).minu = exp_datetime(17:18);

  exp_date(k,:)   = exp_datetime(1:11);
  exp_year(k,:)   = str2num(exp_datetime(8:11));
  exp_month(k,:)  = exp_datetime(4:6);
  exp_day(k,:)    = str2num(exp_datetime(1:2));
  exp_time(k,:)   = exp_datetime(14:end);
  exp_hour(k,:)   = str2num(exp_datetime(14:15));
  exp_minute(k,:) = str2num(exp_datetime(17:18));

end


  
  
% End of file:  psydat_helper2.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
