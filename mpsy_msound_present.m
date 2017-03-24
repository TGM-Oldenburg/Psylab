% Usage: mpsy_msound_present
% ----------------------------------------------------------------------
%   to be called from mpsy_***_present    
%
% this script plays the vector m_outsig using msound, depending on
% variables M.MSOUND_DEVID, M.MSOUND_FRAMELEN and M.MSOUND_NCHAN
%
%   input:   (none), works on global variables
%  output:   (none), presents output signal and controls visual
%                    interval indication 
%
% Copyright (C) 2005 by Eugen Rasumow, Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Eugen Rasumow, Martin Hansen <psylab AT jade-hs.de>
% Date   :  01 Nov 2011
% Updated:  <24 Nov 2011 14:48, martin>
% Updated:  < 1 Nov 2011 10:11, martin>

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



% For the visual interval indication scripts to work, it is REQUIRED
% that both reference signal and test signal have the same duration.
% So, perform the corresponding check, (and possibly set/override
% M.VISUAL_INDICATOR = 0)
mpsy_visual_interval_check;


% number of channels of output signal
nchan = size(m_outsig,2);
% check for matching number channel within msound
if nchan  ~= M.MSOUND_NCHAN,
  % close msound before throwing this error, as msound will need a re-opening
  msound('close');
  error('your signals have %d channels while you specified msound to have %d channels', nchan, M.MSOUND_NCHAN);
end

% length of output signal
siglen   = size(m_outsig,1);
% number of leftover samples
remainder = mod(siglen,M.MSOUND_FRAMELEN);

% zero padding, if there is an uncomlete frame
if remainder>0,
% $$$   % zero-matrix  
% $$$   pad_mat = zeros(M.MSOUND_FRAMELEN - remainder, M.MSOUND_NCHAN);
% $$$   % new outsig
% $$$   m_outsig = cat(1, m_outsig, pad_mat);
  % append zeros to make a last complete frame for msound
  m_outsig(end+(1:M.MSOUND_FRAMELEN-remainder) , :) = 0;
end
% number of complete frames is now:
nframes  = size(m_outsig,1)/M.MSOUND_FRAMELEN;


if M.VISUAL_INDICATOR,
  % prepare a special vector "visual_frame_vec" used for the visual
  % interval indication mechanism during sound output via msound:

  c_tmp = 0.8*[1 1 1];                % background color of answer buttons
  nsamp_presig   = size(m_presig,1);  % duration of pre-signal
  nsamp_postsig  = size(m_postsig,1); % duration of post-signal
  nsamp_quiet    = size(m_quiet,1);   % dur. of quiet pause between intervals
  nsamp_interval = size(m_test,1);    % duration of interval

  % vector for visual indication information:
  %  
  %       interval 1           interval 2         interval 3
  %  pre  ___________  quiet  ___________  quiet  ___________  post
  %  ____|           |_______|           |_______|           |_______  ---> time
  %
  %      1           -1      2           -1      3           -1      (values of visual_frame_vec)
  %
  %
  visual_frame_vec = zeros(nframes,1);
  
  % caluclate frame numbers at which the intervals begin and end
  for kk=1:M.NAFC,  
    % frame number at START of interval kk:
    frame_num = floor( 1+(nsamp_presig + (kk-1)*nsamp_interval +(kk-1)*nsamp_quiet) / M.MSOUND_FRAMELEN);
    visual_frame_vec (frame_num) = kk;
    
    % frame number at END of interval kk:
    frame_num = ceil(    (nsamp_presig +     kk*nsamp_interval +(kk-1)*nsamp_quiet) / M.MSOUND_FRAMELEN);
    visual_frame_vec (frame_num) = -1;  % indicates: all buttons back to normal color
  end
  
end 


% loop through all complete frames
for kk=1:nframes
  % visual identification, when appropriate
  if M.VISUAL_INDICATOR
    if visual_frame_vec(kk) > 0 
      % set active button to color red
      set(afc_but(visual_frame_vec(kk)), 'BackgroundColor', [1 0 0]);  % RED
      drawnow;
    elseif visual_frame_vec(kk) < 0 
      % set all buttons back to background color
      set(afc_but(1:M.NAFC), 'BackgroundColor', c_tmp);  % backgroundcolor
      drawnow;
    else
      % do nothing, as visual_frame_vec(kk) == 0
    end
  end
  
  % calculate sample indices of next frame, and output them:
  idx = (kk-1)*M.MSOUND_FRAMELEN + (1:M.MSOUND_FRAMELEN);
  msound('putSamples', m_outsig(idx,:)); 
end


% End of file:  mpsy_msound_present.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:

