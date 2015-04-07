% Usage: y = mpsy_present
% ----------------------------------------------------------------------
%
%   input:   (none), works on global variables
%  output:   (none), presents signals in AFC fashion, collects and
%                    evaluates subjects answer
%
% This file is based on mpsy_present by Martin Hansen and was modified by
% Georg Stiefenhofer.
% Now allows usage of fixed procedures and presentation in 2-I
% 3-AFC manner. 
%
% Author :  Georg Stiefenhofer, 
% Date   :  November 2007
% allows m-Interval n-AFC procedures. NOTE: right now only m=2, n=3 is implemented.


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



% mount signals in a random N-AFC fashion with the test signal being
% situated in the interval numbered rand_afc
%%% [m_outsig, rand_afc] = mpsy_nafc(m_test, m_ref, M.NAFC, m_quiet, m_presig, m_postsig);
if ~isfield(M,'INAFC')
    mpsy_nafc;
else
    mpsy_mintnafc; 
end
  
  
% ... check for clipping
if max(m_outsig) > 1 | min(m_outsig) < -1,
  mpsy_info(M.USE_GUI, afc_fb, '*** WARNING:  overload/clipping of m_outsig***')
  pause(2);
end

% check ear side, add silence on other side if necessary
if ( (M.EARSIDE~=M_BINAURAL) & (min(size(m_outsig)) == 1) ), 
  if M.EARSIDE == M_LEFTSIDE,
    m_outsig = [m_outsig 0*m_outsig];  % mute right side
  elseif M.EARSIDE == M_RIGHTSIDE,
    m_outsig = [0*m_outsig m_outsig];  % mute left side
  else 
    fprintf('\n\n*** ERROR, wrong value of M.EARSIDE.\n'); 
    fprintf('*** must be M_BINAURAL, M_LEFTSIDE or M_RIGHTSIDE\n');
    return
  end
end

% ... clear possible feedback message in GUI
mpsy_info(M.USE_GUI, afc_fb, '', afc_info, '');

% ... and present
sound(m_outsig, M.FS); 

if M.VISUAL_INDICATOR & M.USE_GUI,
    if isfield(M,'INAFC')
        mpsy_visual_intvl_indctr_2i3afc;
        % NOTE: right now it works only for 2-I 3-AFC!
    else
        mpsy_visual_interval_indicator;  %  acts depending on global variables
    end
else
  if ispc,
    %  Matlab 'sound' works asynchronously on WIN PCs, so: 
    %  pause execution for as long as the signal duration
    pause(length(m_outsig)/M.FS);
  end
end

clear M.ACT_ANSWER;

% get user answer
M.UA = -1;
%while (M.UA < 0 | M.UA > M.NAFC) & M.UA ~= 9,  
while  ~any( M.UA == [ (0:M.NAFC) 8 9]),
  if M.USE_GUI,   %% ----- user answers via mouse/GUI
    set(afc_info, 'String', M.TASK);
    % a pause allows GUI-callbacks to be fetched
    pause(0.5);  
    if isempty(M.UA),  M.UA = -1;  end;
    % NOTE: UA == -100 means, in a 2-interval 3_AFC procedure a listener
    % used the "wrong" buttons, i.e. clicked on the interval buttons and not
    % on the 3-alternatives buttons.
    if M.UA == -100
        set(afc_info, 'String', M.WRONGBUTTON);
        pause(5);
        set(afc_info, 'String', M.TASK);
        M.UA = -1;
    end
  else
    % prompt user for an answer via keyboard
    M.UA = input(M.TASK);
    if isempty(M.UA),  M.UA = -1;  end;
  end    
end

% M.UA contains user answer
switch M.UA,
 case 9,         % user-quit request for this experiment
   mpsy_info(M.USE_GUI, afc_fb, '*** user-quit of this experiment ***', afc_info, '');
   M.QUIT = 1;   % set quit-flag, i.e. whole experiment is aborted completely
   pause(2);
   return;  %  abort this run, i.e. neither save anything
  
 case 8,         % user-quit request for this run
   mpsy_info(M.USE_GUI, afc_fb, '*** user-quit of this run ***', afc_info, '');
   pause(2);
   %  abort this run, i.e. neither save anything:
   return;   
  
 case 0,         % forced wrong answer, i.e. decrease stimulus variable
   M.ACT_ANSWER = 0;  % not correct
   feedback='*** FORCED not correct'; 
  
 case rand_afc,
   M.ACT_ANSWER = 1;  % correct
   feedback='correct';
  
 otherwise,
   M.ACT_ANSWER = 0;  % not correct
   feedback='NOT correct'; 
end



% End of file:  mpsy_present.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
