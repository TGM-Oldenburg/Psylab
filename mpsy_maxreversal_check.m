function y = mpsy_maxreversal_check(n_maxreversal) 

% to called from mpsy_init_run
% ----------------------------------------------------------------------
% Usage: y = mpsy_maxreversal_check(n_maxreversal)
%
%  this function checks whether the max. number of reversals is OK,
%  or whether it is unintentionally low due an older experiment,
%  written prior to psylab version 2.6.
%
%   input:   ---------
%        n_maxreversal   the current maximum number of reserversals
%  output:   ---------
%       y    set to 1 if the number of resersals shall be checked
%            again for any next experiment 
%            set to 0 if the number of reversals shall no longer be
%            checked for any experiment 
%
% Copyright (C) 2014 by Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Martin Hansen <martin.hansen AT jade-hs.de>
% Date   :  29 Mar 2014
% Updated:  <>

%% This file is part of PSYLAB, a collection of scripts for
%% designing and controlling interactive psychoacoustical listening
%% experiments.  
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

if nargin < 1, help(mfilename); return; end;

warn_text = sprintf('The maximum number of reversals is set to only %d in your current experiment.  Maybe this is an error, e.g. because your experiment was designed with an older psylab prior to version 2.6, or maybe this was on purpose?', n_maxreversal);

uiwait( warndlg (warn_text, 'import notice', 'modal'));


yes_answer = 'yes, please ask again';
no_answer  = 'no, please do not ask agin';
question1  = 'would you like to be asked again about number of reversals in any of your experiments in the future?';
user_answer = questdlg(question1, 'important, please read well', ...
                       yes_answer, no_answer, yes_answer);


if strcmp(user_answer, yes_answer),
  y = 1;
else
  y = 0; 
  
  uiwait ( warndlg( 'OK. You will not be asked again. However, should you like to change your mind at a later time, then please copy the the file "mpsy_maxreversal_askagain.m" onto the file "mpsy_maxreversal_check.m"', 'import notice', 'modal'));
  
end


% End of file:  mpsy_maxreversal_check.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
