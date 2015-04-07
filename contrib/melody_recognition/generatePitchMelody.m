% Usage: function sig = generatePitchMelody(pitchtype, v_freq, level_db, len, pause, fs)
% ----------------------------------------------------------------------
%   Function to generate a 2-channel-melody by dichtic-pitches or puretones
%
%   input:  
%           pitchtype   type of pitch which should be uses for generating
%                       the melody (1=puretone, 2=Huggins pitch, 3=binaural
%                       edge pitch, 4=BICEP)
%           v_freq      vektor with frequencies of the melodie-tones
%           level_db    level of tones
%           len         len in s of each tone
%           pause       len in s of pause between tones 
%           fs          sampling frequency
%  output:  
%           sig        2-channel-melody of given frequencies and given
%                      pitchtype
%
% Copyright (C) 2007    Anika Baugart, Benjamin Ekwa, Sven Franz
% Author :  Anika Baugart, Benjamin Ekwa, Sven Franz
% Date   :  21 November 2007

%% This file is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 2 of the License, 
%% or (at your option) any later version.  See the GNU General
%% Public License for more details:  http://www.gnu.org/licenses/gpl
%% This file is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

function sig = generatePitchMelody(pitchtype, v_freq, level_db, len, pause, fs)
sig = [];               % output signal
freq_filter_min = 0;    % lower freq in Hz of nbn
freq_filter_max = 4000; % upper freq in Hz of nbn
winflank = 0.030;       % winflank for on-/offset of tone in s

fftlen = round(len*fs); % fft-length
for freq = v_freq
    sig_r  = []; % right channel vek
    sig_l  = []; % left channel vek
    switch pitchtype
        case 1 % puretone
            sig_r = gensin(freq, 1, len, 0, fs); % generate puretone and store as right channel signal
            sig_l = sig_r; % set left channel to right channel
        case {2, 3, 4} % other pitches
            bbn = randn(len * fs, 1); % generate white gaussian bbn
            sig_r = fft_rect_filt(bbn, freq_filter_min, freq_filter_max, fs); % rect-filtering of the bbn and stored in vek for right channel
            sig_l_fft = fft(sig_r, fftlen); % set left channel in freq-domain to right channel in freq-domain
            sig_l_fft = sig_l_fft(1:end/2); % take the first half fft-result of the left channel
            sig_l_abs = abs(sig_l_fft); % take the absolute of the left channel
            sig_l_phase = angle(sig_l_fft); % take the phase of the left channel
            phase_diff = zeros(size(sig_l_phase)); % define an phase difference vek to compute the phase fifferences of pitches
            freq_tmp = round(freq / fs * fftlen);  % compute the sample number of current frequency
            switch pitchtype
                case 2 % Huggins pitch
                    tmp_vek = round(freq_tmp*(1-.08)) : round(freq_tmp*(1+.08)); % get the indexes of samples where the phasechanging of huggins-pitch happens (freq-8% to freq+8%)
                    phase_diff(tmp_vek) = linspace(0, 2 * pi, length(tmp_vek)); % set these phase-samples to linear growing values (from 0 to 2pi)
                    strname = 'Huggins pitch';
                case 3 % binaural edge pitch
                    phase_diff(freq_tmp : end) = pi; % set phase-samples above freq to pi
                    strname = 'binaural edge pitch';
                case 4 % BICEP
                    phase_diff(freq_tmp : end) = rand (length(phase_diff) + 1 - freq_tmp, 1) * 4 * pi-2*pi; % set phase-samples above freq to random values between -0pi to 4pi (-> -2pi to 2pi)
                    nbn_tmp = fft_rect_filt(randn(len * fs, 1), freq_filter_min, freq_filter_max, fs); % rect-filtering of white gaussian bbn and stored in tmpvek
                    nbn_tmp = abs(fft(nbn_tmp, fftlen)); % compute absolute of tmpvek in freq-domain
                    sig_l_abs(freq_tmp : end)  = nbn_tmp(freq_tmp : end/2); % set phase-samples above freq to random new amplitudes of tmpvek above freq
                    strname = 'BICEP';
            end
            sig_l_fft = sig_l_abs .* exp(i * (sig_l_phase + phase_diff)); % Add phase differenz to current phase and combine absolute and phase to new complex vektor
            sig_l = ifft(sig_l_fft, fftlen, 'symmetric'); % transform signal into timedomain
    end
    sig_r = sig_r / rms(sig_r) .* 10^(level_db / 20); % set level of right channel signal
    sig_l = sig_l / rms(sig_l) .* 10^(level_db / 20); % set level of left channel signal
    sig_l = hanwin(sig_l, round(winflank * fs)); % apply raised cosine flank to onset and offset of right channel
	sig_r = hanwin(sig_r, round(winflank * fs)); % apply raised cosine flank to onset and offset of left channel
	sig = [sig; [sig_r sig_l]; zeros(pause * fs, 2)]; % add current signal to the output and add a pause
end
sig(end - pause * fs + 1: end, :) = []; % remove last pause

% End of file:  generatePitchMelody.m

% Local Variables:
% time-stamp-pattern: "40/Updated:  <%2d %3b %:y %02H:%02M, %u>"
% End:
