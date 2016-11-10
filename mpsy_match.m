function [m_outsig, test_pos] = mpsy_match(m_test, m_ref, mode, m_quiet, m_presig, m_postsig) 

% mount testsignal and reference signal for presentation in matching experiment
% ----------------------------------------------------------------------
% Usage: [m_outsig, test_pos] = mpsy_match(m_test, m_ref, mode, m_quiet, m_presig, m_postsig) 
%
%   input:   ---------
%        m_test     test signal vector   
%        m_ref      reference signal vector   
%        mode       mode of presentation:
%                   0 = random order
%                   1 = alway test signal first      (1 == position of m_test)
%                   2 = alway reference signal first (2 == position of m_test)
%        m_quiet    signal vector played in-between signals
%        m_presig   signal vector played before first signal
%        m_postsig  signal vector played after last signal
% 
%  output:   ---------
%        m_outsig   signal vector containing complete interval sequence
%        test_pos   the interval number containing the test interval
%
% Copyright (C) 2005 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  1 Nov 2006
% Updated:  <10 Mai 2016 14:03, martin>  addition of background signal
% Updated:  < 1 Nov 2006 14:09, hansen>

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


if nargin < 6, help(mfilename); return; end;

switch mode
  
 case 0   % --------------- random order ---------------

      % make random interval index, the one in which the test sig is presented
      test_pos = 1+floor(2*rand(1));

 case 1   % --------------- test signal alway first ---------------
      test_pos = 1;

 case 2   % --------------- reference signal always first ---------------
      test_pos = 2;
   
 otherwise 
      error('wrong presentation mode number mode=%d \n', mode);
end


% mount intervals together ...
switch test_pos
 case 1
        m_outsig = [m_presig; m_test; m_quiet;  m_ref; m_postsig];
 case 2	     	              	               
        m_outsig = [m_presig;  m_ref; m_quiet; m_test; m_postsig];
 otherwise
        fprintf('undefined test_pos: %g, aborting\n',test_pos);
	return;
end


% finally, add the "background signal" if it is present in the workspace
if exist('m_background'),
  % issue an error if the size of m_background does not fit 
  if all(size(m_background) == size(m_outsig)),
    m_outsig = m_outsig + m_background;
  else 
    error('the size of your background signal does not match the size of the output signal \n');
  end
end
      


% End of file:  mpsy_match.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
