function [m_outsig, rand_afc] = mpsy_nafc_singleref(m_test, m_ref, N, m_quiet, m_presig, m_postsig) 

% mount testsignal and reference signal randomly in an N AFC fashion
% ----------------------------------------------------------------------
% Usage: [m_outsig, rand_afc] = mpsy_nafc_singleref(m_test, m_ref, N, m_quiet, m_presig, m_postsig) 
%
%   input:   ---------
%        m_test     test signal vector   
%        m_ref      reference signal vector   
%        N          number of alternative intervals (e.g. 2, 3, or 4)
%        m_quiet    signal vector played in-between signals
%        m_presig   signal vector played before first signal
%        m_postsig  signal vector played after last signal
% 
%  output:   ---------
%        m_outsig   signal vector containing complete interval sequence
%        rand_afc   the interval number containing the test interval
%
%  this file makes use of one single instance of the reference
%  stimulus as found in m_ref.  If you need to have n-1 different
%  instances of a reference in an N-AFC trial (running noise), then
%  use the script mpsy_nafc.m.  
%
%
% Copyright (C) 2005 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  31 Mrz 2005
% Updated:  < 3 Nov 2005 14:09, hansen>

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

% THIS used to be the file mpsy_nafc.m prior to version 1.97  


if nargin < 6, help(mfilename); return; end;

switch N
  
  case 2   % --------------- 2AFC ---------------
      % make random interval index, the one in which the test sig is presented
      rand_afc = 1+floor(2*rand(1));

      % mount intervals together ...
      switch rand_afc
       case 1
	m_outsig = [m_presig; m_test; m_quiet;  m_ref; m_postsig];
       case 2	     	              	               
	m_outsig = [m_presig;  m_ref; m_quiet; m_test; m_postsig];
       otherwise
	fprintf('undefined rand_afc:%.1f, aborting\n',rand_afc);
	return;
      end
      
  case 3   % --------------- 3AFC ---------------
      % make random interval index, the one in which the test sig is presented
      rand_afc = 1+floor(3*rand(1));

      % mount intervals together ...
      switch rand_afc
       case 1
	m_outsig = [m_presig; m_test; m_quiet;  m_ref; m_quiet;  m_ref; m_postsig];
       case 2	     	              	               
	m_outsig = [m_presig;  m_ref; m_quiet; m_test; m_quiet;  m_ref; m_postsig];
       case 3	     	              	               
	m_outsig = [m_presig;  m_ref; m_quiet;  m_ref; m_quiet; m_test; m_postsig];
       otherwise
	fprintf('undefined rand_afc:%.1f, aborting\n',rand_afc);
	return;
      end

  case 4   % --------------- 4AFC ---------------
      % make random interval index, the one in which the test sig is presented
      rand_afc = 1+floor(4*rand(1));

      % mount intervals together ...
      switch rand_afc
       case 1
	m_outsig = [m_presig; m_test; m_quiet;  m_ref; m_quiet;  m_ref; m_quiet;  m_ref; m_postsig];
       case 2	     	              	               		                       
	m_outsig = [m_presig;  m_ref; m_quiet; m_test; m_quiet;  m_ref; m_quiet;  m_ref; m_postsig];
       case 3	     	              	               		                       
	m_outsig = [m_presig;  m_ref; m_quiet;  m_ref; m_quiet; m_test; m_quiet;  m_ref; m_postsig];
       case 4	     	              	               		                       
	m_outsig = [m_presig;  m_ref; m_quiet;  m_ref; m_quiet;  m_ref; m_quiet; m_test; m_postsig];
       otherwise
	fprintf('undefined rand_afc:%.1f, aborting\n',rand_afc);
	return;
      end

  otherwise 
      error('N-AFC not yet implemented for N=%d, aborting\n', N);
end


% End of file:  mpsy_nafc.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
