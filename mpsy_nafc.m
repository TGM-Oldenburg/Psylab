% Usage: mpsy_nafc
% ----------------------------------------------------------------------
%
%   input:   (none), works on global variables
%  output:   (none), mounts signal intervals in AFC fashion
%
% Copyright (C) 2005 by Martin Hansen, Jade Hochschule, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  31 Mrz 2005
% Updated:  <10 Mai 2016 14:02, martin>  addition of background signal
% Updated:  <16 Nov 2015 16:36, martin>
% Updated:  < 3 Nov 2005 14:09, hansen>

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


%if nargin < 6, help(mfilename); return; end;

if exist('m_ref')
  
  if exist('m_ref1'),
    error('found variables "m_ref1" and also "m_ref" in your workspace.  Only one OR the other should be used!');
  end
  
  % call the "single-reference" N-AFC procedure, i.e. the case with
  % only one instance of the reference signal "m_ref"
  [m_outsig, M.rand_afc] = mpsy_nafc_singleref(m_test, m_ref, M.NAFC, m_quiet, m_presig, m_postsig);

else
    
  % implement the "multiple/different-references" N-AFC procedure,
  % i.e. the case where (n-1) different instances of a reference signal 
  % are present in an n-AFC experiment.  This is, e.g., needed in
  % case of random noise maskers, where every noise interval is
  % made up of a "new" uncorrelated noise.  
  switch M.NAFC
  
   case 2   % --------------- 2AFC ---------------

       % this case N==2 is identical to the "single-reference" case 
       % (see above), where the refenrence is stored in variable 'm_ref'
       
       if exist('m_ref1'),
	 error('found variable called "m_ref1" in your workspace.  It should probably be called "m_ref" ?');
       end
            
   case 3   % --------------- 3AFC ---------------
    
      % make random interval index, the one in which the test sig is presented
      M.rand_afc = 1+floor(3*rand(1));

      % select random permutation of m_ref1 and m_ref2
      rand_ref_perm = randperm(2);
      eval(['m_ref_a = m_ref' num2str(rand_ref_perm(1)) ';']);
      eval(['m_ref_b = m_ref' num2str(rand_ref_perm(2)) ';']);
	
      % mount intervals together ...
      switch M.rand_afc
	case 1
	  m_outsig = [m_presig; m_test;  m_quiet; m_ref_a; m_quiet; m_ref_b; m_postsig];
        case 2	     	              	               
	  m_outsig = [m_presig; m_ref_a; m_quiet; m_test;  m_quiet; m_ref_b; m_postsig];
        case 3	     	              	               
	  m_outsig = [m_presig; m_ref_a; m_quiet; m_ref_b; m_quiet; m_test;  m_postsig];
        otherwise
	  error('wrong value of rand_afc:%.1f, aborting\n', M.rand_afc);
      end

   case 4   % --------------- 4AFC ---------------
    
      % make random interval index, the one in which the test sig is presented
      M.rand_afc = 1+floor(4*rand(1));

      % select random permutation of m_ref1 and m_ref2 and m_ref3
      rand_ref_perm = randperm(3);
      eval(['m_ref_a = m_ref' num2str(rand_ref_perm(1)) ';']);
      eval(['m_ref_b = m_ref' num2str(rand_ref_perm(2)) ';']);
      eval(['m_ref_c = m_ref' num2str(rand_ref_perm(3)) ';']);
	
      % mount intervals together ...
      switch M.rand_afc
        case 1
	  m_outsig = [m_presig; m_test;  m_quiet; m_ref_a; m_quiet; m_ref_b; m_quiet; m_ref_c; m_postsig];
        case 2	     	              	               		                       
	  m_outsig = [m_presig; m_ref_a; m_quiet; m_test;  m_quiet; m_ref_b; m_quiet; m_ref_c; m_postsig];
        case 3	     	              	               		                       
	  m_outsig = [m_presig; m_ref_a; m_quiet; m_ref_b; m_quiet; m_test;  m_quiet; m_ref_c; m_postsig];
        case 4	     	              	              		                       
	  m_outsig = [m_presig; m_ref_a; m_quiet; m_ref_b; m_quiet; m_ref_c; m_quiet; m_test;  m_postsig];
        otherwise
	  error('wrong value of rand_afc:%.1f, aborting\n', M.rand_afc);
      end

  otherwise 
      error('N-AFC not yet implemented for N=%d, aborting\n', N);
  end
  
end


% finally, add the "background signal" if it is present in the workspace
if exist('m_background'),
  % issue an error if the size of m_background does not fit 
  if all(size(m_background) == size(m_outsig)),
    m_outsig = m_outsig + m_background;
  else 
    error('the size of your background signal does not match the size of the output signal \n');
  end
end



% End of file:  mpsy_nafc.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
