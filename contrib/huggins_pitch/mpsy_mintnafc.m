% mount testsignal and reference signal randomly in an m-interval n-AFC fashion
% ----------------------------------------------------------------------
%
% This file is based on mpsy_nafc by Martin Hansen and was modified by
% Georg Stiefenhofer.
% Author :  Georg Stiefenhofer
% Date:     Nov 2007
% allows m-Interval n-AFC procedures.
%
% NOTE: right now only m=2, n=3 is implemented.
%
% NOTE: For 2-interval 3-AFC procedures a test stiumuls and a reference is
% presented to the subject who needs to response in which direction the
% test stimulus is different or whether it is the same. Thus 2 test stimuli
% and one reference are created in the USER-script and one of the test
% stimuli is choosen here.

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




if ~exist('m_ref','var') || ~exist('m_test1','var') || ~exist('m_test2','var')
    disp('Sorry, m_ref, m_test1 or m_test2 NOT FOUND.')
    error('Choosing a 2-interval 3-AFC procedure you have to compute a reference and 2 test stimuli.');
end


if M.NAFC ~=3 || M.INAFC ~=2
    error('Sorry, right now only 2-interval 3-AFC procedures are implemented!')
end
% --------------- 2I - 3AFC ---------------
% make random interval index, the one in which the test sig is presented
rand_afc = 1+floor(3*rand(1));

% mount intervals together ...
switch rand_afc
    case 1
        m_outsig = [m_presig;  m_ref; m_quiet;  m_test1; m_postsig];
    case 2
        m_outsig = [m_presig;  m_ref; m_quiet;    m_ref; m_postsig];
    case 3
        m_outsig = [m_presig;  m_ref; m_quiet;  m_test2; m_postsig];
    otherwise
        fprintf('undefined rand_afc:%.1f, aborting\n',rand_afc);
        return;
end
