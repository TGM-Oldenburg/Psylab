% Usage: mpsy_2up_1down
% ----------------------------------------------------------------------
%  
%    set new value of measurement variable M.VAR and stepsize
%    variable M.STEP according to the adaptive 2up-1down paradigm.  
%    (Levitt, "Transformed up-down procedures in psychoacoustics",
%    1971, JASA 49, p.467-477.)  
%
%   input:  
%           (none) works on set of global variables M.* 
%           evaluates especially M.ACT_ANSWER
%  output:  
%           (none), updated set of "M.*" variables 
%
% Copyright (C) 2003, 2004  Martin Hansen  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  15 May 2003
% Updated:  <18 Mar 2014 10:41, martin>
% Updated:  <28 Feb 2006 19:44, mh>
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


% answer == 1 means: correct (in case of N-AFC experiment)
% answer == 0 means: false (in case of N-AFC experiment)

if isfield(M, 'PC_CONVERGE'),
  warning('The value of M.PC_CONVERGE (%g) is ignored by THIS adaptive rule', M.PC_CONVERGE);
end


% ==================================================
% Check for occurrence of a new reversal
% ==================================================
if length(M.ANSWERS) >= 3,
  
  % ----- a) uppper reversal:  
  % last answer was correct and the 2 answers before were wrong
  if  M.ANSWERS(end) == 1 &  all(M.ANSWERS(end-2:end-1) == 0),
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
  % last 2 answers were wrong and the one before was correct
  if all(M.ANSWERS(end-1:end) == 0)  &  all(M.ANSWERS(end-2) == 1),
    % yep, new lower reversal found!    
    M.REVERSAL = M.REVERSAL + 1;
    % DO NOT adapt step size, as this is only done at upper reversals
    
    % append newest index of reversal to list of all indices of reversals
    M.LOWER_REV_IDX = [M.LOWER_REV_IDX length(M.ANSWERS)];
    %% fprintf('M.LOWER_REV_IDX: %d   \n',  M.LOWER_REV_IDX )
  end
end


% for security, ensure M.STEP cannot become negative
if M.STEP <= 0,
  error(' variable M.STEP (%g)  is <= 0', M.STEP);
end

% ==================================================
% apply adaptive   2-up-1-down   rule
% ==================================================
if length (M.ANSWERS) < 2,
  prev_answer = 0;
else
  prev_answer = M.ANSWERS(end-1);
end
%
if M.ACT_ANSWER == 1,
  M.VAR = M.VAR - M.STEP;    % 1 correct answer, DEcrease stimulus
  M.DIRECTION = M_DOWN;
else
  % (M.ACT_ANSWER == 0)
  if prev_answer == 0 & M.DIRECTION ~= M_UP,
    M.VAR = M.VAR + M.STEP;  % 2 succesive wrong answers, INcrease stimulus
    M.DIRECTION = M_UP;
  else
    M.DIRECTION = M_STAY;    % wait what to do
  end
end



% End of file:  mpsy_2up_1down.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
