function version = mpsy_check_psydat_file(filename, nversion) 

% check psydat version number of existing psydat file 
% ----------------------------------------------------------------------
% Usage: version = mpsy_check_psydat_file(filename, nversion)
%
%   input:   ---------
%        filename    name of the (psydat-)file to be checked
%        nversion    [optional, default = 3] version number of the
%                    psydat file. This argument is needed, in case the
%                    file is created because it did not yet exist.  

%  output:   ---------
%        version    The version number of the psydat-file-format.
%                   Note, this is the version of psydat-files which need
%                   not correspond to the version number of psylab itself. 
%
%    Returns the psydat file version number.  
%    If filename does not yet exist as a file, it will be created and a
%    one-line header written into it, marking its psydat version as
%    specified by the argument version. 
%
%
%
% Copyright (C) 2006 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  22 Okt 2006

% Updated:  <27 Okt 2016 15:06, martin>
%        - change of filename to mpsy_check_psydat_file.m instead of 
%          previous filename mpsy_check_psydat_check.m
%        - enable new psydat version 3, as needed since introduction of
%          constant stimuli method.   
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

if nargin < 2,
  nversion = 3;   % set to current default psydat version number 
end

if round(nversion)~=nversion | nversion<2 | nversion>3,
  error('unsupported psydat file version number %d', nversion);
end


% A version 2 file should have THIS line as a header:
v2_header = '######## psydat version 2 header ########  DO NOT change THIS line ########';
v2_toks = mpsy_split_lines_to_toks(v2_header)';

% A version 3 file should have THIS line as a header:
v3_header = '######## psydat version 3 header ********  DO NOT change THIS line ########';
v3_toks = mpsy_split_lines_to_toks(v3_header)';


% check whether the psydat file already exists in the current directory:
if exist(fullfile(pwd,filename)) == 2,
  
  if nargin >= 2,
    warning('2nd argument nversion (%d) not used, because file "%s" already exists', nversion, filename);
  end
  
  % open the file ...
  [fid_tmp,msg] = fopen(filename, 'r');
  if ~strcmp(msg,''),
    error('fopen on file % returned with message %s\n', filename, msg);
  end
  % ... and read in the first 12 strings in the file
  tmp = textscan(fid_tmp, '%s', 12);
  stmp = tmp{1};
  fclose(fid_tmp);

  if length(stmp) < 11,
    error('the file %s does not appear to be in a correct format of a psydat file.');
  end
      
  % compare for appearance of header line keywords in first line of the psydat file
  if all(strcmp(v2_toks([2 3 5 7 8 9 10 11]), stmp([2 3 5 7 8 9 10 11]))),
    % now the 4th element should be the version number (as a string)
    version = str2num(char(stmp(4)));
  else
    % no match found or unkown content found, so set version to -1
    version = -1;
  end
  
else
  % the file didn't exist so far, so create it and 
  % make a distinct one-line header corresponding to the psydat version
  [fidm,message] = fopen( filename, 'a' );
  switch nversion
   case 2
     fprintf(fidm, '%s\n', v2_header);
     version = 2;
   case 3
     fprintf(fidm, '%s\n', v3_header);
     version = 3;
   otherwise
     error('unsupported psydat file version number %d', nversion);
  end
  
  fclose(fidm);
  
end



% End of file:  mpsy_check_psydat_file.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
