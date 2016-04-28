% Usage: mpsy_det_reversal_adj_step()
% ----------------------------------------------------------------------
%          Detect whether a reversal has occurred.  If so, adapt
%          step size accordingly by continued halving until the
%          minimal step size has been reached.
%
%   input args:  (none) works on set of global variables M.*
%  output args:  (none) processes subjects' answer and protocolls everything
%
% Copyright (C) 2006 by Martin Hansen, Jade Hochschule
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  01 Mrz 2006
% Updated:  <23 Nov 2012 22:24, martin>  (updated comments)

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



% The general algorithm is valid for all types of n-up-m-down methods.
% For the most common ones: 1up-1-down, 1up-2down, 2up-1-down, the
% following algorithm is easier to read when explicitly written out.
% This could be done in the scripts mpsy_*up_*down.m

% Definition: At a reversal point, M.VAR has a local maximum,
% i.e. the direction is changing from "up" to "down".  This is the
% case, when the last M.ADAPT_N_DOWN answers were all correct and
% the last M.ADAPT_N_UP answers BEFORE THOSE(!) were all wrong.


% detect a new reversal:
if length(M.ANSWERS) > max(M.ADAPT_N_DOWN, M.ADAPT_N_UP),
    idx_mustbe_correct = length(M.ANSWERS) - (0:M.ADAPT_N_DOWN-1);
    idx_mustbe_wrong   = length(M.ANSWERS) - (0:M.ADAPT_N_UP-1) - M.ADAPT_N_DOWN;
    % *********************************************************************
    % inserted by R Kuehler (29-10-2013): provide a reversal point if the direction is changend
    % due to the "I Don't Know"-answer in UWUD, i.e. the "I Don't Know"-answer is
    % treated like the uncorrect answer due to the reversal definition (see above)
    if M.ANSWERS(idx_mustbe_wrong) == -3 % check if "I Don't Know" was pressed
        if  M.ANSWERS(idx_mustbe_correct) == 1 && M.ANSWERS(idx_mustbe_wrong) == -3
            % yep, new reversal found!
            M.REVERSAL = M.REVERSAL + 1;
            % Now adapt step size M.STEP by halving it, ...
            % ... but do not go below the minimal stepsize M.MINSTEP!
            %             if ~mod(M.REVERSAL,2) % count as a reversal every second change of direction [Kaernbach, 2001]
            M.STEP = max(M.MINSTEP, M.STEP / 2);
            %             end
            % append newest index of reversal to list of all indices of reversals
            M.REV_IDX = [M.REV_IDX length(M.ANSWERS)];
        end
        % *********************************************************************
    elseif  all(M.ANSWERS(idx_mustbe_correct)) && ~any(M.ANSWERS(idx_mustbe_wrong))
        % yep, new reversal found!
        M.REVERSAL = M.REVERSAL + 1;
        % Now adapt step size M.STEP by halving it, ...
        % ... but do not go below the minimal stepsize M.MINSTEP!
        %         if ~mod(M.REVERSAL,2) % count as a reversal every second change of direction [Kaernbach, 2001]
        M.STEP = max(M.MINSTEP, M.STEP / 2);
        %         end
        
        
        % append newest index of reversal to list of all indices of reversals
        M.REV_IDX = [M.REV_IDX length(M.ANSWERS)];
        
    end
end



% End of file:  mpsy_det_reversal_adj_step.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
