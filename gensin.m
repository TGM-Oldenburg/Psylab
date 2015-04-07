function y = gensin(freq, ampl, len, phase, fsamp)

% generate sinussoidal waveform
% ----------------------------------------------------------------------
% Usage: y = gensin(freq, ampl, len, phase, fsamp)
%
%   input:   ---------
%      freq     frequency      [Hz]
%      ampl     amplitude      (linear value)
%      len      signal length  [s] 
%      phase    startphase     [degree(0 ... 360)] (optional, default 0)
%      fsamp    sampling freq. [Hz] (optional, default 48000)
%  output:   ---------
%      y        sinusoidal waveform
%
% Copyright (C) 2003 by Martin Hansen, Fachhochschule OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  07 Oct 2003
% Updated:  <19 Jul 2011 10:00, martin>
% Updated:  < 7 Oct 2003 10:03, hansen>

%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

if nargin < 3, help(mfilename); return; end;
if nargin < 5,   
  fsamp = 48000;
  fprintf(' ***info(%s):  fsamp is %g Hz\n',mfilename,fsamp);
end
if nargin < 4,   
  phase = 0;
end

t = (0:(1/fsamp):len-(1/fsamp))';           % time 
y = ampl * sin( 2*pi*( freq*t + phase/360 ) );

% End of file:  gensin.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
