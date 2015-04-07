% set-script for jnd_frequency.m
%
% Usage:  jnd_frequencyset
%
% Copyright (C) 2003       Martin Hansen, FH OOW
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  26 Jun 2005
% Updated:  <26 Jun 2005 17:58, mh>

%% This file makes use of PSYLAB, a collection of scripts for
%% designing and controling interactive psychoacoustical listening
%% experiments.  See http://www.hoertechnik-audiologie.de/psylab/
%%
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

M.VAR  = 33 ;     % start frequency increment factor
M.STEP = 16 ;    % start STEP-size (

tdur   = 0.4;    % Dauer des Traegers [s]
a0     = sqrt(2)*10^(M.PARAM(2)/20);    % seine Amplitude

% sinusoid
ton1 = gensin(M.PARAM(1), a0, tdur, 0, M.FS);
% hanning flanks
m_ref = hanwin(ton1, round(0.05*M.FS));


% quiet signals
pauselen  = 0.2;
m_quiet   = zeros(round(pauselen*M.FS),1);
m_postsig = m_quiet(1:end/2);
m_presig  = m_quiet;

% $$$ pauselen  = 0.4;
% $$$ m_quiet   = zeros(round(pauselen*M.FS),1);
% $$$ m_postsig = m_quiet(1:2);
% $$$ m_presig  = m_quiet(1:2);
% $$$ 


% End of file:  jnd_frequencyset.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
