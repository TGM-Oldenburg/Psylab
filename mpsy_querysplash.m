function y = mpsy_querysplash() 

% ----------------------------------------------------------------------
% Usage: y = mpsy_querysplash()
%
%   input:   ---------   
%      (none)
%
%  output:   ---------
%      y   a flag value:
%            0 (false) signifies, not to display a splash screen 
%            1 (true)  signifies, to display a splash screen and ask user
%                      for agreement with license etc. 
%
% Author :  Martin Hansen <martin.hansen AT jade-hs.de>
% Date   :  20 Okt 2016
% Updated:  <>

%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl


% do (y=1) or don't (y=0) show a splash screen at the beginning of a new experiment 


% default upon delivery:  y=1
y = 1;   

% alternative:   don't show splash 
% y = 0;  



% End of file:  mpsy_querysplash.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
