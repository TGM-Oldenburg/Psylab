% Usage:  mpsy_adapt_uwud()
% ----------------------------------------------------------------------
%
%    set new value of measurement variable M.VAR and stepsize
%    variable M.STEP according to the "unforced weighted up-down"
%    paradigm. 
%    (Kaernbach, "Adaptive threshold estimation with unforced-choice tasks", 
%    2001, Perception & Psychophysics, 63(8), p. 1377-1388)    
%
%   input:  
%           (none) works on set of global variables M.* 
%           evaluates especially M.ACT_ANSWER
%  output:  
%           (none), updated set of "M.*" variables 
%
% Copyright (C) 2009 by Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  24 Sep 2009
% Updated:  <17 Mar 2014 17:38, mh>

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


% answer == 1 means: correct (in case of N-AFC experiment)
% answer == 0 means: false (in case of N-AFC experiment)
% answer == -3 means: undecided, go up (in case of UWUD-N-AFC experiment)



% ==================================================
% Check for occurrence of a new reversal
% ==================================================
if length(M.ANSWERS) >= 2,
  
  % ----- a) uppper reversal
  % last answer was correct and the one before was wrong or undecided
  if M.ANSWERS(end) == 1 &  (M.ANSWERS(end-1) == 0 | M.ANSWERS(end-1) == -3) ,
    % yep, new upper reversal found!    
    M.REVERSAL = M.REVERSAL + 1;
    % Now adapt step size M.STEP by halving it, ...
    % ... but do not go below the minimal stepsize M.MINSTEP! 
    M.STEP = max(M.MINSTEP, M.STEP / 2); 
    
    % append newest index of reversal to list of all indices of reversals
    M.UPPER_REV_IDX = [M.UPPER_REV_IDX length(M.ANSWERS)];
    %% fprintf('M.UPPER_REV_IDX: %d   \n',  M.UPPER_REV_IDX )
  end
  
  % ----- b) uppper reversal
  % last answer was wrong or undecided and the one before was correct
  if (M.ANSWERS(end) == 0 | M.ANSWERS(end) == -3) &  M.ANSWERS(end-1) == 1,
    % yep, new lower reversal found!    
    M.REVERSAL = M.REVERSAL + 1;
    % DO NOT adapt step size, as this is only done at upper reversals
    
    % append newest index of reversal to list of all indices of reversals
    M.LOWER_REV_IDX = [M.LOWER_REV_IDX length(M.ANSWERS)];
    %% fprintf('M.LOWER_REV_IDX: %d   \n',  M.LOWER_REV_IDX )
  end
end


% for security, ensure M.STEP to be positive
if M.STEP <= 0,
  error(' variable M.STEP (%g)  is <= 0', M.STEP);
end


% check reasonable value of the desired percent correct at convergence:
% it must be below 1 (100%) and above chance level (1/M.NAFC)
if M.PC_CONVERGE >= 1 | M.PC_CONVERGE <= 1/M.NAFC, 
  error('value M.PC_CONVERGE=%g not feasible (above 1 or below 1/M.NAFC)', M.PC_CONVERGE);
end

% ============================================================
% apply adaptive   "UWUD" (unforced weighted up-down)   rule:
% ============================================================
% calculate separate step sizes for
%  - correct answer -->  going down,
%  - wrong answer --> going up, and 
%  - unsure ("I don't know") answer --> going up as well, but smaller step

% variable M.STEP is defined to hold the step size S_correct for going down 
M.STEP_DOWN   = M.STEP;    
% now use equation (5) from  Kaernbach (2001) to calculate new step size
% S_incorrect for going up. 
M.STEP_UP     = M.PC_CONVERGE/(1-M.PC_CONVERGE) * M.STEP_DOWN;
% and use equation (7) from  Kaernbach (2001) to calculate new step size
% S_unshure for going up. 
M.STEP_UNSURE = (M.PC_CONVERGE-1/M.NAFC)/(1-M.PC_CONVERGE) * M.STEP_DOWN;


% note that the above 3 step SIZES (M.STEP_UNSURE, M.STEP_UP, M.STEP_DOWN) all 
% have positive sign.  The DIRECTION of change is reflected in the following code:
switch M.ACT_ANSWER
  case -3
    M.VAR = M.VAR + M.STEP_UNSURE; % unshure answer, INcrease stimulus by M.STEP_UNSURE
  case 0
    M.VAR = M.VAR + M.STEP_UP;     % wrong answer, INcrease stimulus by M.STEP_UP
  case 1  
    M.VAR = M.VAR - M.STEP_DOWN;   % correct answer, DEcrease stimulus by M.STEP_DOWN
  otherwise
    error('wrong value M.ACT_ANSWER (%d), should be 0, 1, or -3 for UWUD method', M.ACT_ANSWER);  
end




% End of file:  mpsy_adapt_wud.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
