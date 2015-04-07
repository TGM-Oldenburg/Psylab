function mue = mpsy_optdet(cur_diff_repr, template) 

% calculate decision variable in optimal detection process
% ----------------------------------------------------------------------
% Usage:  c = mpsy_optdet(cur_diff_repr, template) 
%
%   input:   ---------
%     cur_diff_repr   difference of representation of current interval 
%                     and representation of reference interval  
%     template        "the template", i.e. normalized difference of 
%                     representations of supra-threshold interval
%                     and reference interval  
%  output:   ---------
%      mue            cross correlation value between the two input
%                     vectors, considered the mean of a gaussian
%                     random variable
%
% Copyright (C) 2007         Martin Hansen, FH OOW  
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  19 Mrz 2007
% Updated:  <20 Mar 2007 14:08, hansen>

%% This file is not official part of PSYLAB 
%% and it is *not* GNU GPL copyrighted!


if nargin < 2, help(mfilename); return; end;

% calculate cross correlation (zero lag) and consider its result
% the mean ("mue") of a gaussian random variable, see Dau et al. (1996)
corr_mue = cur_diff_repr .* template;

%%% these lines are taken from the file 'pemo_optdet.m' of T. Dau 
[dim1,dim2,dim3] = size(corr_mue);
optFactor = sqrt(dim1 * dim2 * dim3);
mue = mean(corr_mue,1);

if dim2 >= 2
	mue=mean(mue,2);
end

if dim3 >= 2
	mue=mean(mue,3);
end

mue = mue * optFactor;
%%% end of lines from 'pemo_optdet.m'


% End of file:  mpsy_optdet.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
