function y = mpsy_internal_repr(x, f0, fs, type) 

% calculate internal representation for modeling purposes
% ----------------------------------------------------------------------
% Usage: y = mpsy_internal_repr(x, f0, fs, type)
%
%   input:   ---------
%    x      input signal
%    f0     center freq. of auditory filter
%    fs     sampling freq.
%    type   model type, e.g. type of BM filter
%
%  output:   ---------
%    y      internal representation according to Dau (1996) model.  
%           Default type:
%           - 4th order gammatone filter (Patterson/Moore/Hohmann)
%           - halfwave rectification + 1st order lowpass filter
%           - adaptation loops (Pueschel 1988)
%
% Copyright (C) 2007 by Martin Hansen, FH OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  12 Mrz 2007
% Updated:  <>

%% This file is not official part of PSYLAB 
%% and it is *not* GNU GPL copyrighted!


if nargin < 3, help(mfilename); return; end;

if nargin > 3,
  warning('argument "type" not yet evaluated');
end


% basilar membrane filter
y1 = real(gammatone_filter(x, f0, fs, 1));

% halfwave rectification and 1st order lowpass
[b,a] = butter(1, f0/fs);
y2 = filter(b, a, max(y1,0) );

% adaptation loops
%% y = adapt(y2, fs);      % alte version mex-file adapt.dll
% neue version mit limitierung des overshoot
y = nlal_lim(y2, fs, 15);   % argument "15" gemaess CASP (Jepsen et al. 2008)


% End of file:  mpsy_internal_repr.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
