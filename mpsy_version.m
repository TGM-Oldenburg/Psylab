function [psylab_version, psylab_major, psylab_minor] = mpsy_version() 

% tell the version of psylab
% ----------------------------------------------------------------------
% Usage: [psylab_version, psylab_major, psylab_minor] = mpsy_version() 
%
%   input:   ---------
%     (none)
%  output:   ---------
%     psylab_version    version as a string
%     psylab_major      major version number
%     psylab_minor      minor version number
%
%
% Copyright (C) 2005 Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  30 Nov 2005
% Updated:  <14 Jan 2004 19:14, hansen>

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

psylab_major = 2;
psylab_minor = 9;

psylab_version = [ num2str( psylab_major ) '.' num2str(psylab_minor) ];


if nargout < 1,
  fprintf('     This is PSYLAB, Version %s\n', psylab_version); 
end

  
% End of file:  mpsy_version.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
