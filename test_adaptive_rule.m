function y = test_adaptive_rule() 

%
% ----------------------------------------------------------------------
% Usage: y = test_adaptive_rule()
%
%   input:   ---------
%  output:   ---------
%
% Copyright (C) 2008         Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  10 Jan 2008
% Updated:  <>

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
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl




%% analyze/verify correct behaviour of adaptive up-down rule

mpsy_init;


M.ADAPT_N_UP   = 1 ;    % number of succesive wrong answers required for "up"
M.ADAPT_N_DOWN = 3 ;    % number of succesive correct answers required for "down"

M.MAXREVERSAL  = 5 ;    % number of reversals required as stop criterion
M.USE_GUI      = 0;     % 1/0  = yes/no
M.FEEDBACK     = 1;
M.DEBUG        = 1;

M.MINSTEP      = 0.1 ;    % minumum step size, in units of M.VARUNIT
M.VAR          = 4;    
M.STEP         = 8*M.MINSTEP;



M.EXPNAME      = mfilename;
M.NUM_PARAMS   = 1;
M.SNAME        = 'dullyname';
M.VARNAME      = 'dullyvar';
M.VARUNIT      = 'varunit';
M.PARAMNAME    = 'dullypar';
M.PARAMUNIT    = 'parunit';
M.PARAM        = 0;


fprintf(' adaptive rule:  %d-up-%d-down', M.ADAPT_N_UP, M.ADAPT_N_DOWN);
% clear previous run history, if any
mpsy_init_run;

while (M.REVERSAL < M.MAXREVERSAL) | (M.STEP > M.MINSTEP)

  % save current VAR and STEP 
  M.VARS  = [M.VARS M.VAR];
  M.STEPS = [M.STEPS M.STEP];

  % generate the new simulated user answer:
  rand_val = randn(1);
  if rand_val < M.VAR
    M.ACT_ANSWER = 1;  % meaning "correct" answer
    % this definition/implementation yields to:   P_correct == normcdf(M.VAR)
  else
    M.ACT_ANSWER = 0;  % meaingn "not correct"
  end    
  
  % append the current answer to the array of all answers
  M.ANSWERS = [M.ANSWERS M.ACT_ANSWER];

  
  % now apply adaptive N-up M-down rule:
  % adapt M.VAR, recalculate step size, etc.
  eval( ['mpsy_' num2str(M.ADAPT_N_UP) 'up_' num2str(M.ADAPT_N_DOWN) 'down;'] );
  
  
  % check whether to start data collection: 
  % note: a new M.STEP and M.VAR have just been calculated from the last answer
  if M.STEP == M.MINSTEP & M.STEPS(end) > M.MINSTEP,
    % count reversals during measurement phase again starting from 0
    M.REVERSAL = 0;
    if M.FEEDBACK, 
      mpsy_info(M.USE_GUI, afc_fb, 'starting measurement phase');
      pause(0.5)
    end
  end
  
  if M.DEBUG,
      htmp = gcf;    % remember current figure
      % show last stimuli and answers
      figure(111);   mpsy_plot_feedback;
      if M.USE_GUI,
	figure(htmp);  % make previous figure current again, e.g. the answer GUI
      end
  end
  pause(0.05)

end   % while REVERSAL loop

figure(111)
mpsy_plot_feedback;

fprintf('M.VAR:  %g,   normcdf(M.VAR): %g\n', M.VAR, normcdf(M.VAR));


% End of file:  test_adaptive_rule.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
