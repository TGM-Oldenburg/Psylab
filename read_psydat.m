function [x,y] = read_psydat(s_name, exp_name) 

% Usage: [x,y] = read_psydat(s_name, exp_name) 
% ----------------------------------------------------------------------
%     read (extract) those data from psydat_* file 
%        -- which is in NEW VERSION 3 FORMAT -- 
%     that belong to the specified subject and experiment.  The
%     filename of the psydat-file is determined from the argument
%     s_name which is append to "psydat_".
%     Output data into structure x and, optionally, same data in
%     matrix format in y 
% 
%   input:   ---------
%          s_name   subject name (initial as found in data file)
%        exp_name   experiment name (as found in data file)
%
%  output:   ---------
%      x   struct variable containing all data belonging to s_name and exp_name
%      y   same data as x, but numeric data only, and in matrix format
%
% Copyright (C) 2006   Martin Hansen, FH OOW  
% Author :  Martin Hansen,  <psylab AT jade-hs.de>
% Date   :  10 Sep 2003

% Updated:  <23 Feb 2017 11:34, martin>
% Updated:  <25 Apr 2016 15:00, martin>
% Updated:  <23 Okt 2006 00:10, hansen>
% Updated:  <14 Jan 2004 11:30, hansen>

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


file_name = ['psydat_' s_name];
[fid1,msg] = fopen(file_name,'r');
if ~strcmp(msg,''),
  fprintf('fopen on file %s returned with message "%s"\n',file_name, msg);
  return
end

if mpsy_check_psydat_file(file_name) == 1,
  error('file "%s" is probably in psydat format version 1.  Try read_psydat_v1.m instead', file_name);
end


% count correct entries (=completed experimental runs) found in psydat file
entry = 0;
% count line number in psydat file
line_number = 0;

stop_flag = 0;

while 1,
  
  % read one next line from psydat file
  lin = fgets(fid1);  line_number = line_number+1;
  if lin == -1, break; end;  % we are now at EOF, so exit the while(1)-loop
  
  % split it into space-separated words
  tok = mpsy_split_lines_to_toks(lin);

  % check whether we have a line starting a new block
  if length(tok) == 7 & strcmp(tok(5), 'npar') & strcmp(tok(7), '####') ,
    
    % second token on the line is the experiment name
    ename = char(tok(2));
    % third token is subject name
    sname = char(tok(3));
    %%% fprintf('found entry with s_name= %s, experiment= %s\n', char(tok(3)), char(tok(2)) );
    
    if strcmp(tok(3), s_name),  % check for correct subject name
      
      if strcmp(tok(2), exp_name), % check for correct experiment name

        % good, we are at the starting line of a block of lines
        % matching the requested subject+experiment 
        entry = entry+1;
        
        if strcmp(tok(1), '##adapt##'), 
          experiment_type = 'adapt';
        elseif strcmp(tok(1), '##const##'), 
          experiment_type = 'const';
        else
          error('   Unknown experiment type "%s" in psydat file %s.\n   You might want to try the old version read_psydat_v2', char(tok(1)), file_name);
        end
        
        nparam = str2num(char(tok(6)));
        x.date(entry)    = tok(4);
        
       for k=1:nparam,
         % get next line
         lin = fgets(fid1);  line_number = line_number+1;
          % split it into space-separated words
          tok = mpsy_split_lines_to_toks(lin);
          
          if length(tok) == 5 & strcmp(tok(2), sprintf('PAR%d:',k)),
            x.par(k).name(entry)  = tok(3);
            x.par(k).value(entry) = str2num(char(tok(4)));
            x.par(k).unit(entry) = tok(5);
          else
            fclose(fid1);
            error('sorry, psydat file garbled  in line %d at entry %d. Expecting a line for parameter #%d here.', ...
                  line_number, entry, k);
          end
        end % for all parameters
      
        % get next line in the file
        lin = fgets(fid1);   line_number = line_number+1;
        % split it into space-separated words
        tok = mpsy_split_lines_to_toks(lin);
        
        % check whether this line holds the ADAPT: info
        if strcmp(tok(2), 'ADAPT:')
          
          if ~strcmp(experiment_type, 'adapt')
            error('sorry, psydat file garbled  in line %d. Found "ADAPT" line for a non adaptive experiment.',  line_number);
          end
            
          % output the name of the adaptive rule, as a cell
          x.adapt_method(entry) = tok(3);
          if length(tok) > 3,
            % output value of p_correct, as a cell string in order to
            % allow empty values, see else-case
            x.adapt_pcorrect(entry) = tok(4);
          else
            % non existent information on p_correct is specified as such 
            x.adapt_pcorrect(entry) = {''};
          end
          
          % and then get next line in the file
          lin = fgets(fid1);   line_number = line_number+1;
          % split it into space-separated words
          tok = mpsy_split_lines_to_toks(lin);
        end
        
        % alternatively, check whether that line holds the CONST: info
        if strcmp(tok(2), 'CONST:') & strcmp(tok(3), 'num_presentations') 
          
          if ~strcmp(experiment_type, 'const')
            error('sorry, psydat file garbled  in line %d. Found "CONST" line for a non-conststim. experiment.',  line_number);
          end
            
          % output the number of the const. stim. presentations
          x.num_presentations(entry) = str2num(char(tok(4)));
          
          % and then get next line in the file
          lin = fgets(fid1);   line_number = line_number+1;
          % split it into space-separated words
          tok = mpsy_split_lines_to_toks(lin);
        end
        
        % alternatively, check whether that line holds the VAL: info
        if strcmp(tok(2), 'VAL:')
          x.run(entry).vars = str2num(char(tok(3:2:end)));
          x.run(entry).answers = str2num(char(tok(4:2:end)));
        
          % and then get next line in the file
          lin = fgets(fid1);   line_number = line_number+1;
          % split it into space-separated words
          tok = mpsy_split_lines_to_toks(lin);
        end
    

        % now we should be at the last line fo the current block,
        % containing the experimental result:  values for threshold
        % or percent-correct: 
        if length(tok) == 6 & ~strcmp(tok(1), '%%-----') & strcmp(experiment_type, 'adapt'),
          x.varname(entry)    = tok(1);
          x.threshold(entry)  = str2num(char(tok(2)));  % the threshold itself
          x.thres_sd(entry)   = str2num(char(tok(3)));  % its std. dev.
          x.thres_min(entry)  = str2num(char(tok(4)));  % min. values during meas. phase
          x.thres_max(entry)  = str2num(char(tok(5)));  % max. values during meas. phase
          x.varunit(entry)    = tok(6);
        elseif length(tok) == 5 & strcmp(tok(4), 'prob_correct') & strcmp(experiment_type, 'const'),
          x.varname(entry)    = tok(1);                 % the variable's name
          x.var(entry)        = str2num(char(tok(2)));  % the (const.) value of M.VAR
          x.varunit(entry)    = tok(3);                 % its unit
          x.prob_correct(entry)  = str2num(char(tok(5)));  % the probability correct 
        else
          fclose(fid1);
          error('sorry, psydat file garbled in line %d at entry %d. Expecting a line for the threshold data here.', ...
                line_number, entry, k);
        end
        
      else
        % nothing to do, we are on a line with a different experiment

      end  % if correct exp.name
      
    else
      % This case should not happen during normal use of psylab.
      % However, we might get here, when a psydat file got renamed
      % or, e.g., in case of a non-unique subject name with
      % mixed/upper/lower case letters.   
      fprintf('*** WARNING, found a different subject name ("%s") for experiment %s.\n', sname, exp_name);
      fprintf('             that line (entry after %d) is skipped\n', entry);
    end % if correct subject name
    
  else
    % nothing to do here.  the current line does not belong to the
    % requested experiment.  so in the qwhile(1)-loop the next line
    % of the psydat file will be read
    
  end % if correct starting line
  
end % while(1) loop
fclose(fid1);

if entry > 0,
  fprintf('*** info:  read_psydat found %d matching entries in %s\n', entry, file_name);
else
  warning('*** I''m sorry, no appropriate entries found in file %s\n', file_name);
  x = []; y = [];
  return
end

non_unique = 0;
for k=2:length(x.varname),
  if ~strcmp(x.varname(1),x.varname(k)),  non_unique=non_unique+1;  end 
  if ~strcmp(x.varunit(1),x.varunit(k)),  non_unique=non_unique+2;  end 
  for l=1:nparam,
    if ~strcmp(x.par(l).name(1), x.par(l).name(k)), non_unique=non_unique+2^(2*l-1); end 
    if ~strcmp(x.par(l).unit(1), x.par(l).unit(k)), non_unique=non_unique+2^(2*l); end 
  end
  
  if non_unique,
    fprintf('***\n*** WARNING:  non-unique name or unit in y, at data set #%d  (id=d%d|b%s)\n***\n',...
            k, non_unique, dec2bin(non_unique));
    break
  end
end


% Set a second output variable y, containing same data as x, but skip
% all variables containings string data etc. und leave only numeric
% data, i.e. M.PARAM(:,:) and threshold data.  Arrange them in a
% matrix format
if nargout > 1,
  if non_unique == 0,
    
    if strcmp(experiment_type, 'adapt'),
      
      y(:,1) = x.threshold' ;
      y(:,2) = x.thres_sd'  ;
      y(:,3) = x.thres_min' ;
      y(:,4) = x.thres_max' ;
      for k=1:nparam,
        y(:,4+k) = x.par(k).value' ;
      end
      
      fprintf('*** info:  read_psydat: meaning of the %d cols of y (2nd output argument):\n', 4+nparam)
      fprintf('           threshold, thres_sd, thres_min, thres_max, par1')
      for k=2:nparam,   fprintf(', par%d', k);  end
      fprintf(' \n');
      
    elseif strcmp(experiment_type, 'const'),
      
      y(:,1) = x.prob_correct' ;
      y(:,2) = x.num_presentations' ;
      y(:,3) = x.var' ;
      for k=1:nparam,
        y(:,3+k) = x.par(k).value' ;
      end
      
      fprintf('*** info:  read_psydat: meaning of the %d cols of y (2nd output argument):\n', 3+nparam)
      fprintf('           prob_correct, num_presentations, variable, par1')
      for k=2:nparam,   fprintf(', par%d', k);  end
      fprintf(' \n');
      
    end

  else
    warning('2nd output argument set to zero because of non-unique name(s) or unit(s) in psydat file.');
    y = 0;
  end
end


 
  
% End of file:  read_psydat.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
