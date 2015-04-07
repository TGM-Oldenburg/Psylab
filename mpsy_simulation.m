% Usage: y = mpsy_simulation
% ----------------------------------------------------------------------
%
%   input:   (none), works on global variables
%  output:   (none), apply Dau (1996) model calculations
%
% Copyright (C) 2007         Martin Hansen, FH OOW  
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  15 Mar 2007
% Updated:  <29 Mar 2007 16:33, hansen>
% Updated:  <20 Mar 2007 14:09, hansen>

%% This file is not official part of PSYLAB 
%% and it is *not* GNU GPL copyrighted!



% (only) in case of very first trial ...
if length(M.VARS) == 1 & M.MODE == M_SIMULATION,
  % ... generate the template from the supra threshold test stimulus
  
  % M.NUM_TEMPLATES should hold the number of repetitions of stimulus
  % generation (via user script) and template calculation (via mpsy_template)
  if ~isfield(SIMU, 'NUM_TEMPLATES'),
    % if not yet set, set it to default value (no repetitions/averaging) 
    SIMU.NUM_TEMPLATES = 1;   
  end
  
  m_template_sum = 0;   % for accumulating the templates
  rep_ref0_sum   = 0;   % for accumulating the reps of the masker alone
  
  fprintf(' template calculation: ')
  for kk = 1:SIMU.NUM_TEMPLATES,
    % repeatedly generate new template and new rep0, which get stored in
    % (global) variables 'm_template' and 'rep_ref0'
    
    fprintf('%d ', kk)
    % note: the user script has just been executed, either in the calling
    % script mpsy_simu_main or in this loop, see below.
    mpsy_template;                 
    m_template_sum = m_template_sum + m_template;   % add new template
    rep_ref0_sum = rep_ref0_sum + rep_ref0;         % add new rep0
    
    if M.DEBUG>1,
      figure(120)
      subplot(2,2,1)
      plot(m_template);
      subplot(2,2,2)
      plot(m_template_sum);
      subplot(2,2,3)
      plot(rep_ref0);
      subplot(2,2,4)
      plot(rep_ref0_sum);
    end
    

    % repeatedly produce new stimulus signals, either for use in next for-loop
    % iteration, or (when in last iteration) as the first "new" stimulus
    % not having being averaged during templates calculation
    eval([M.EXPNAME 'user']);
  end
  fprintf('\n')
    
  m_template = m_template_sum / SIMU.NUM_TEMPLATES;  % normalize template
  rep_ref0   = rep_ref0_sum / SIMU.NUM_TEMPLATES;    % normalize rep0

end


rep_test = mpsy_internal_repr(m_test, SIMU.F0, M.FS); 
cc_test  = mpsy_optdet(rep_test-rep_ref0, m_template);

if exist('m_ref')
  rep_ref  = mpsy_internal_repr(m_ref,  SIMU.F0, M.FS); 
  cc_ref   = mpsy_optdet(rep_ref-rep_ref0, m_template);
else
  for k=1:M.NAFC-1,
    eval(['rep_ref = mpsy_internal_repr(m_ref' num2str(k) ',  SIMU.F0, M.FS);']);
    cc_ref(k) = mpsy_optdet(rep_ref-rep_ref0, m_template);
  end
end

% difference between current test intervals' CC and largest of the
% (NAFC-1) reference intervals' CC
mue = max(0, cc_test - max(cc_ref));	

%% now we implement equation (A8) of Dau et al. (1996).
%% we avoid the need for the statistics toolbox' function 'normcdf'
%% (integral of normal distribution) by exploiting the following
%% identity:    
%% normcdf(x) == 1 - 0.5*erfc(x/sqrt(2)) == 0.5*(1 + erf(x/sqrt(2)))
switch M.NAFC,
  case 2, 
    prob = 1 - 0.5*erfc( (mue / SIMU.SIGMA * 0.707 - 0) / sqrt(2) );
  case 3
    prob = 1 - 0.5*erfc( (mue / SIMU.SIGMA * 0.765 - 0.423) / sqrt(2) );
  case 4
    prob = 1 - 0.5*erfc( (mue / SIMU.SIGMA * 0.810 - 0.668) / sqrt(2) );
  otherwise
    error('value of M.NAFC not yet supported, must be 2, 3, or 4');
end


%% make the decision, based on the probability of correct answer:
r = rand;    % uniform random variable between 0 and 1
if prob > r,
  M.ACT_ANSWER = 1;  % correct
  if M.FEEDBACK > 1, 
    feedback='correct';
  else
    feedback = '';    % omit textual correctness feedback in simulations
  end
else
  M.ACT_ANSWER = 0;  % not correct
  if M.FEEDBACK > 1, 
    feedback='NOT correct'; 
  else
    feedback = '';    % omit textual correctness feedback in simulations
  end
end

  

if M.DEBUG>1,
  figure(120)
  subplot(4, 2, 1)
  plot(m_supra); title('m_supra')
  subplot(4, 2, 3)
  plot(m_test); title('m_test')
  subplot(4, 2, 5)
  if exist('m_ref'),
    plot(m_ref);  title('m_ref')
  else
    plot(m_ref1);  title('m_ref1')
  end
  subplot(4, 2, 7)
  plot(m_template);  title('m_template')
  subplot(4, 2, 2)
  plot(rep_supra); title('rep_supra')
  subplot(4, 2, 4)
  plot(rep_test); title('rep_test')
  subplot(4, 2, 6)
  plot(rep_ref);  title('rep_ref')
  subplot(4, 2, 8)
  plot(rep_test-rep_ref0);  title(sprintf('rep_test-rep_ref0, cc_test=%g',cc_test));
  %figure(122)
end

    

% End of file:  mpsy_simulation.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
