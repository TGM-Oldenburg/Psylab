% Usage: y = mpsy_adapt_wud()
% ----------------------------------------------------------------------
%
%    set new value of measurement variable M.VAR and stepsize
%    variable M.STEP according to the "weighted up-down" paradigm.
%    (Kaernbach, "Simple adaptive testing with the weighted up-down
%    method", 1991, Perception & Psychophysics, 49, p. 227-229)   
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


% $$$ % for compatibility, set these 2 variables as they are needed by mpsy_det_reversal_adj_step
% $$$ M.ADAPT_N_UP   = 1;
% $$$ M.ADAPT_N_DOWN = 1;
% $$$ % check whether a new reversal has occurred. if so, adapt step size  
% $$$ mpsy_det_reversal_adj_step;
% $$$ 

% Check for occurrence of a new reversal
if length(M.ANSWERS) >= 2,
  
  % ----- a) uppper reversal
  % last answer was correct/1/"go down", and the one before was wrong/0/"go up"
  if M.ANSWERS(end) == 1 &  M.ANSWERS(end-1) == 0,
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
  % last answer was wrong/0/"go up" and the one before was correct/1/"go down"
  if M.ANSWERS(end) == 0 &  M.ANSWERS(end-1) == 1,
    % yep, new lower reversal found!    
    M.REVERSAL = M.REVERSAL + 1;
    % DO NOT adapt step size, as this is only done at upper reversals
    
    % append newest index of reversal to list of all indices of reversals
    M.LOWER_REV_IDX = [M.LOWER_REV_IDX length(M.ANSWERS)];
    %% fprintf('M.LOWER_REV_IDX: %d   \n',  M.LOWER_REV_IDX )
  end
end


if M.STEP <= 0,
  error(' variable M.STEP (%g)  is <= 0', M.STEP);
end


% check reasonable value of the desired percent correct at convergence:
% it must be below 1 (100%) and above chance level (1/M.NAFC)

% however, as WUD can also be used in matching experiments, where
% "chance level" has no meaning, so 
if M.PC_CONVERGE >= 1, 
  error('value M.PC_CONVERGE=%g not feasible (above 1)', M.PC_CONVERGE);
end

if isfield(M, 'NAFC') & M.PC_CONVERGE <= 1/M.NAFC, 
  error('value M.PC_CONVERGE=%g not feasible (below 1/M.NAFC)', M.PC_CONVERGE);
end




% --------------------------------------------------
% "WUD" (weighted up-down) rule:
% --------------------------------------------------
% calculate separate step size for going up and down:
% variable M.STEP is defined to hold the step size S_down for going down
M.STEP_DOWN = M.STEP;    
% now use equation (1) from  Kaernbach (1991) to calculate new step size
% S_up for going up. 
M.STEP_UP   = M.PC_CONVERGE/(1-M.PC_CONVERGE) * M.STEP_DOWN;


if M.ACT_ANSWER == 0,
  M.VAR = M.VAR + M.STEP_UP;    % 1 wrong answer, INcrease stimulus by M.STEP_UP
else
  % (M.ACT_ANSWER == 1)
  M.VAR = M.VAR - M.STEP_DOWN;  % 1 correct answer, DEcrease stimulus by M.STEP_DOWN
end




% End of file:  mpsy_adapt_wud.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
