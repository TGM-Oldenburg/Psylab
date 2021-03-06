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



% ==================================================
% Check for occurrence of a new reversal
% ==================================================
if length(M.ANSWERS) >= 2,
  
  % ----- a) uppper reversal
  % last answer was correct/1/"go down", and the one before that was wrong/0/"go up"
  if M.ANSWERS(end) == 1 &  M.ANSWERS(end-1) == 0,
    % yep, new upper reversal found!    
    M.REVERSAL = M.REVERSAL + 1;
    % Now adapt step size M.STEP by halving it, ...
    % ... but do not go below the minimal stepsize M.MINSTEP! 
    if ~M.REVERSED_UP_AND_DOWN,
      % the normal case, M.STEP is positive
      M.STEP = max(M.MINSTEP, M.STEP / 2); 
    else
      % the reversed case, M.STEP is negative
      M.STEP = min(M.MINSTEP, M.STEP / 2); 
    end
    
    % append newest index of reversal to list of all indices of reversals
    M.UPPER_REV_IDX = [M.UPPER_REV_IDX length(M.ANSWERS)];
    %% fprintf('M.UPPER_REV_IDX: %d   \n',  M.UPPER_REV_IDX )
  end
  
  % ----- b) lower reversal
  % last answer was wrong/0/"go up" and the one before that was correct/1/"go down"
  if M.ANSWERS(end) == 0 &  M.ANSWERS(end-1) == 1,
    % yep, new lower reversal found!    
    M.REVERSAL = M.REVERSAL + 1;
    % DO NOT adapt step size, as this is only done at upper reversals
    
    % append newest index of reversal to list of all indices of reversals
    M.LOWER_REV_IDX = [M.LOWER_REV_IDX length(M.ANSWERS)];
    %% fprintf('M.LOWER_REV_IDX: %d   \n',  M.LOWER_REV_IDX )
  end
end


% for security, ensure M.STEP cannot become zero, or have wrong
% sign in combination with the flag M.REVERSED_UP_AND_DOWN
if M.STEP == 0,
  error(' variable M.STEP  is = 0');
end
if ~M.REVERSED_UP_AND_DOWN & M.STEP < 0,
  % in "normal" definition of "up" and "down", M.STEP must be positive:
  error(' M.STEP (%g) must be positive', M.STEP);
end
if M.REVERSED_UP_AND_DOWN & M.STEP > 0,
  % in "reversed" definition of "up" and "down", M.STEP must be negative:
  error('If you choose the reversed definition of "up" and "down", then M.STEP (%g) must be negative', M.STEP);
end


% check reasonable value of the desired percent correct at convergence:
% it must be below 1 (100%) ...
if M.PC_CONVERGE >= 1, 
  error('value M.PC_CONVERGE=%g not feasible (above 1)', M.PC_CONVERGE);
end
% ... and above chance level (1/M.NAFC).  However, WUD can also be
% used in matching experiments, where "chance level" has no
% meaning.  Therefore (note slight difference relative to the UWUD case):
if isfield(M, 'NAFC') & M.PC_CONVERGE <= 1/M.NAFC, 
  error('value M.PC_CONVERGE=%g not feasible (below 1/M.NAFC)', M.PC_CONVERGE);
end



% ============================================================
% apply adaptive   "WUD" (weighted up-down)   rule:
% ============================================================
% calculate separate step size for going up and down:
% variable M.STEP is defined to hold the step size S_down for going down:
M.STEP_DOWN = M.STEP;    

% now use equation (1) from  Kaernbach (1991), (e.g. at 
% http://www.emotion.uni-kiel.de/fileadmin/emotion/team/kaernbach/publications/1991a_kae_p_p.pdf )
% to calculate new step size S_up for going up.   
%
% However, NOTE that that equation (1) and also the sentence following
% immediately contains a MAJOR TYPO.  Quote from Kaernbach (1991):
% %%  --- QUOTE BEGIN ---
% %%      S_up * p = S_down * (1-p).               (eq. 1)
% %%  For X_75, it   follows   that   S_up/S_down = 1/3.   
% %%  --- QUOTE END ---
% That above equation is WRONG!  The sentence following it fits to
% the equation, which is wrong, however.
%
% The next sentence then, in the original paper, gives a CORRECT EXAMPLE
% %%  --- QUOTE BEGIN ---
% %%  The rule for a convergence to the X_75 point would thus read: 
% %%  Decrease the Level 1 step after each correct response, and
% %%  increase it 3 steps  after each incorrect response. 
% %%  --- QUOTE END ---

% So the correct equilibirum condition for convergence is:
%   stepsize_UP * probability_UP = stepsize_DOWN * probability_DOWN
%   where probability_DOWN  = probability for a correct answer:
%   
M.STEP_UP   = M.PC_CONVERGE/(1-M.PC_CONVERGE) * M.STEP_DOWN;


% Note that the 2 step SIZES (M.STEP_UP, M.STEP_DOWN) both
% have the same sign as M.STEP. That is: positive sign in the
% normal case and negative sign in the reversed-up-down-case.   
% The DIRECTION of change is then reflected in the following code: 

if M.ACT_ANSWER == 0,
  % 1 wrong answer, 
  %     i.e. INcrease stimulus variable (normal case, M.STEP_UP is positive)
  %    resp. DEcrease stimulus variable (reversed case, M.STEP_UP is negative)
  M.VAR = M.VAR + M.STEP_UP;    
else
  % (M.ACT_ANSWER == 1)
  %     i.e. DEcrease stimulus variable (normal case, M.STEP_DOWN is positive)
  %    resp. INcrease stimulus variable (reversed case, M.STEP_DOWN is negative)
  M.VAR = M.VAR - M.STEP_DOWN;  
end




% End of file:  mpsy_adapt_wud.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
 
