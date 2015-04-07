% Function to generate a struct with names and frequencies of melodies stored in an ASCII data file
%
% Usage:	melodies = get_melodies(filename, octav_offset)
% Input:	filename:       filename of textfile with melody information
%           octav_offset:   (optional) transpose notes by x octaves   
% Output:   melodies:       struct with names and frequencies of melodies
%
% Copyright (C) 2007    Anika Baugart, Benjamin Ekwa, Sven Franz
% Author :  Anika Baugart, Benjamin Ekwa, Sven Franz
% Date   :  21 November 2007

%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.
%% See the GNU General Public License for more details:
%% http://www.gnu.org/licenses/gpl

function melodies = get_melodies(filename, octav_offset)
if nargin < 2 % 
    octav_offset = 0;
end
octav = 4;

% frequency of standard pitch A4
freq_a = 440;
% frequency of fundamental note C4
freq_c = freq_a*2^(-9/12);
% names of fundamental notes
note_Names = {'c' 'c#' 'd' 'd#' 'e' 'f' 'f#' 'g' 'g#' 'a' 'a#' 'h'};

%% open data file
fid = fopen(filename);

melodies = [];
while 1
    tmp  = fgetl(fid); % melody name at current file-position
    if ~ischar(tmp) % check for a string input
        break
    end
    if ~isempty(strtrim(tmp)) && ~strcmpi(tmp(1), '%') 
        melodies(length(melodies)+1).name = tmp; % add melody name to struct as new melody 
        melodies(length(melodies)).freq = [];
        % try to ignore commentaries (starting with %)
        tmp = '%';
        while isempty(strtrim(tmp)) || (~isempty(strtrim(tmp)) && strcmpi(tmp(1), '%'))
            tmp = fgetl(fid);
        end

        hilfsfreq = strtrim(tmp); % read frequencies as string
        while ~isempty(hilfsfreq)
            idx = find(strcmpi(note_Names, hilfsfreq(1)) == 1) - 1; % get fundamental note name
            hilfsfreq(1) = [];
            if strcmpi(hilfsfreq(1), '#') % check for upper semitone
                idx = idx + 1;
                hilfsfreq(1) = [];
            elseif strcmpi(hilfsfreq(1), 'b') % check for lower semitone
                idx = idx - 1;
                hilfsfreq(1) = [];
            end
            freq = freq_c * 2^(idx/12) * 2^(str2double(hilfsfreq(1)) + octav_offset - octav); % calculate frequency of current note
            melodies(length(melodies)).freq(length(melodies(length(melodies)).freq)+1) = freq; % add current frequency to melody
            hilfsfreq(1) = [];
            hilfsfreq = strtrim(hilfsfreq);
        end
    end
end
fclose(fid);

% End of file:  get_melodies.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
