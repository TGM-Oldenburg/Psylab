function y = fft_rect_filt(x, f1, f2, fsamp, notch, high_idx_offset) 

% rectangular shape bandpass/notch filter via fft
% ---------------------------------------------------------------------
% Usage: y = fft_rect_filt(x, f1, f2, fsamp, notch, high_idx_offset) 
%
%   input:  ----------
%                x  input signal
%               f1  lower edge freq (min.: 0,  max.:fsamp/2)
%               f2  upper edge freq (min.: f1, max.:fsamp/2)
%            fsamp  samplingrate of x
%            notch  (optional, default 0) set to 1, to specify
%                   notch-filter instead of band-pass  
%  high_idx_offset  (optional, default 0) offset for upper edge
%                   frequency index.  Set to -1 for use of fft_rect_filt
%                   for a filterbank purpose, so that neighbour bands
%                   have zero overlap samples.
%  output:  ----------
%                y  filtered output signal
%
%   Filter signal x having samplingrate fsamp via FFT, so that
%   frequencies between f1 and f2 (both inclusive) are passed through,
%   unless notch is set ~=0, which means pass frequencies outside of
%   f1 and f2.  Output to y.  The filter has rectangular shape in
%   frequency domain, i.e., it has very steep slopes of approx. 300 dB
%   damping within the bandwidth of 1 FFT-bin.  It is possible that
%   f1==f2, resulting in a filter passing through (or notching) only 1
%   single FFT-bin.  Because of the FFT, this script works fastest
%   with signal lengths that are powers of 2.
%
%   For filterbank purposes, high_idx_offset should be set to -1 to
%   assure that neighbouring bands have exactly zero samples
%   overlap at the common edge frequencies, see the following example: 
%   a = fft_rect_filt(x,    0,  300, fs, 0, -1);
%   b = fft_rect_filt(x,  300, 1000, fs, 0, -1);
%   c = fft_rect_filt(x, 1000, 2000, fs, 0, -1);
%
% Copyright (C) 2003 by Martin Hansen, Fachhochschule OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>

% Date   :  11 May 2003
% Updated:  < 5 Sep 2006 09:04, hansen>
% Updated:  <13 Feb 2005 13:50, mh>
% Updated:  <19 Jun 2003 11:26, hansen>

%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

if nargin < 4, help(mfilename); return; end;


if min(size(x)) ~= 1,
  error(' ***sorry, only for mono signals\n');
end
%
if f1 > f2 | max(f1,f2) > (fsamp/2) | min(f1,f2) < 0,
  error(' ***  0 <= f1 <= f2 <= (fsamp/2) is required \n');
end
%  
if nargin < 5,    notch = 0;            end
if nargin < 6,    high_idx_offset = 0;  end
 

f = fft(x);
N = length(f);

% general calculation of MATLAB spectral index:   idx = 1+N*f/fs
%
%      .___________________.___________________.  ----> frequency
%      |   |     |         |          |    |   |
%freq  0   f1    f2       fs/2                 fs
%idx   1   idx1  idx2     1+N/2     idx3 idx4  (N+1)

idx1 = 1+floor(N * f1/fsamp ) ;
idx2 = 1+floor(N * f2/fsamp ) + high_idx_offset;
idx3 = N - idx2 + 2;   % idx3 == (N+1) - (idx2-1)
idx4 = N - idx1 + 2;   % idx4 == (N+1) - (idx1-1)

%disp([idx1 idx2 idx3 idx4 N])

% copy spectrum signal
ff = f;

% Now, set to zero parts of the spectrum, so that a band pass
% between f1 and f2 is reached:
% The spectrum at idx1:idx2 (both inclusive) is kept UNTOUCHED, 
% and LIKEWISE at indices idx3:idx4 at negative frequencies.  
% Everything outside these index-ranges is set to ZERO.
% 
% The following three lines also work for true lowpass situation:
%   f1=0 ==> idx1=1 ==> idx4 = N+1 
%   because both index ranges (1:idx1-1), and (idx4+1:end) are EMPTY(!)
% They also work for a true highpass situation where
%   f2=fs/2 ==> idx2 = N/2+1 ==> idx3 = N/2+1
%   because the index range (idx2+1:idx3-1) is EMPTY(!)

ff ( 1      : idx1-1 ) = 0;  % empty index range in case of LOW  pass
ff ( idx2+1 : idx3-1 ) = 0;  % empty index range in case of HIGH pass
ff ( idx4+1 : N      ) = 0;  % empty index range in case of LOW  pass

if notch ~= 0,
  % make a notch instead a pass
  ff = f - ff;
end

% inverse fft
y = ifft(ff);

% mathematically, the result should be purely real valued, but there
% will always be a small calculation error/noise due to double
% precision, which leads to an imaginary part ~=0.  It is, however,
% approx. a factor 1e-12 smaller relative to the real part.
% So, make it artificially real
y = real(y);

% End of file:  fft_rect_filt.m



% Local Variables:
% time-stamp-pattern: "50/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
