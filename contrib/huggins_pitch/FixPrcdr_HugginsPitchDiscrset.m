% set-script for  FixPrcdr_HugginsPitch.m
%
% Usage:   FixPrcdr_HugginsPitch
%
% Copyright (C) 2007       G.Stiefenhofer
% Author :    G.Stiefenhofer
% Date   :  November 2007


%% This file makes use of PSYLAB, at collection of scripts for
%% designing and controling interactive psychoacoustical listening
%% experiments.  
%%
%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl


%NOTE:
% m_ref is created in user script!

% quiet signals
pauselen  = 0.5;
m_quiet   = zeros(round(pauselen*M.FS),1);
m_postsig = m_quiet(1:end/20);
m_postsig = [m_postsig m_postsig];
m_presig  = m_quiet;
m_presig = [m_presig m_presig];
m_quiet = [m_quiet m_quiet];




