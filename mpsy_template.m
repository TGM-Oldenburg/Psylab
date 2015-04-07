% Usage: y = mpsy_template
% ----------------------------------------------------------------------
%
%   input:   (none), works on global variables
%  output:   (none), generates the template ("the optimal detector")
%
% Copyright (C) 2007 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  15 Mrz 2007
% Updated:  <20 Mar 2007 14:09, hansen>

%% This file is not official part of PSYLAB 
%% and it is *not* GNU GPL copyrighted!


% save the first supra-threshold test stimulus
m_supra    = m_test;  
% representation of supra-threshold test stimulus
rep_supra  = mpsy_internal_repr(m_supra, SIMU.F0, M.FS); 

if exist('m_ref')
  % representation of reference (i.e. "masker alone" according to Dau96 )
  rep_ref0   = mpsy_internal_repr(m_ref, SIMU.F0, M.FS); 
else
  % calculate the "mean" representation of the NAFC-1 reference intervals
  rep_ref0 = 0;
  for k=1:M.NAFC-1,
    eval(['rep_ref0 = rep_ref0 + mpsy_internal_repr(m_ref' num2str(k) ', SIMU.F0, M.FS);']);
  end
  rep_ref0 = rep_ref0 / (M.NAFC-1);
end
  
% difference of representations
m_template = rep_supra - rep_ref0;
% now the template needs to be normalized


%%% these lines are adapted from the file 'pemo_template.m' of T. Dau.
%%% start of SI normdet
[LX1, LX2, LX3] = size(m_template);	
norm_rms = sqrt(mean(m_template.^2, 1));
if LX2 >= 2
	norm_rms = sqrt(mean(norm_rms.^2, 2));
end
if LX3 >= 2
	norm_rms = sqrt(mean(norm_rms.^2, 3));
end
m_template = m_template / norm_rms;
%%% end of SI normdet

%%% start of SI cordet
% normalization changed 13-01-2005 14:16
% rev 1.00.3
% normalization is now done as in SI version (1/samplerateOfInternalRep) 
norm_downwardCompatible96 = sqrt((30000/12000)/(M.FS/SIMU.REP_RESAMPLE));  

% this normalization is needed to make the model downwardcompatible with the very early
% pre 1996 fs=30000, fixed-duration simus, see Schelles comment in SI src.
m_template = m_template * norm_downwardCompatible96;
%%% end of SI cordet


% End of file:  mpsy_template.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
