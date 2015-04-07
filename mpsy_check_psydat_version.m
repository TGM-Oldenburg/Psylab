function version = mpsy_check_psydat_version(filename) 

% check psydat version number of existing psydat file 
% ----------------------------------------------------------------------
% Usage: version = mpsy_check_psydat_version(filename)
%
%   input:   ---------
%            filename    name of the (psydat-)file to be checked
%  output:   ---------
%            version     the version number of the psydat-file-format.
%                        This need not correspond to the version of psylab
%
% 
%    if filename does not exist, it is created and a one-line
%    header written into it, marking it as a psydat version 2
%    file. 
%
% Copyright (C) 2006 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  22 Okt 2006
% Updated:  <22 Okt 2006 23:49, hansen>

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


% read in first line of file.  A version 2 file should have THIS
% line as a header:
v2_header = '######## psydat version 2 header ########  DO NOT change THIS line ########';
v2_toks = mpsy_split_lines_to_toks(v2_header)';


% check whether the psydat file already exists in the current directory:
if exist(fullfile(pwd,filename)) == 2,
  
  % read in the first 12 strings in the file
  [fid_tmp,msg] = fopen(filename, 'r');
  if ~strcmp(msg,''),
    error('fopen on file % returned with message %s\n', filename, msg);
  end
  tmp = textscan(fid_tmp, '%s', 12);
  stmp = tmp{1};
  fclose(fid_tmp);

  % compare for appearance of header line keywords in first line of the file
  if length(stmp) < 11,
    error('the file %s does not appear to be in a correct format of a psydat file.');
  end
      
  if all(strcmp(v2_toks([2 3 5 7 8 9 10 11]), stmp([2 3 5 7 8 9 10 11]))),
    % now the 4th element should be the version number (as a string)
    version = str2num(char(stmp(4)));
  else
    % no match found or unkown content found, so guess version==1
    version = 1;
  end
  
else
  % the file didn't exist so far, so create it and 
  % make a distinct one-line header for a psydat version 2 file
  [fidm,message] = fopen( filename, 'a' );
  fprintf(fidm, '%s\n', v2_header);
  fclose(fidm);
  version = 2;
end



% End of file:  mpsy_check_psydat_version.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
