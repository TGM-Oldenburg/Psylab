% Usage: y = mpsy_debug()
%
% performs a debugging on the adaptive transformed up-down-algorithm.
% 
%   input:   (none), acts on a set of global variables
%  output:   (none)
%
% Copyright (C) 2006 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  27 Feb 2006
% Updated:  <28 Feb 2006 20:48, mh>

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



figure(113)

plot(M.VARS, 'b.-'); 
hold on;
plot((2:length(M.VARS)), diff(M.VARS), 'mo-'); 
plot(M.ANSWERS, 'r<-');
plot((2:length(M.ANSWERS)), diff(M.ANSWERS), 'g*-'); 
plot(M.STEPS, 'y>-');
plot(M.REV_IDX, M.VARS(M.REV_IDX), 'kp', 'MarkerSize', 12);
grid on
hold off; 

legend('M\_VARS', 'diff(M\_VARS)', 'M\_ANSWERS', 'diff(M\_ANSWERS)', ...
       'M\_STEPS', 'reversal-point', 0);


fprintf('*** info:  M.VAR         %f \n', M.VAR);
fprintf('*** info:  M.STEP        %f \n', M.STEP);
fprintf('*** info:  M.REVERSAL    %d \n', M.REVERSAL);
fprintf('*** info:  M.MAXREVERSAL %d \n', M.MAXREVERSAL);


% End of file:  mpsy_debug.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
