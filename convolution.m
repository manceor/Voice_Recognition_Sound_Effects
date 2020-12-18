function convolution(~)
% Load in impulse response
[impulse, Fs] = audioread('impulse.wav');
impulse = impulse(:,1);
t = linspace(1, 5, 479999);
% The line below is used if you want to use this fcn with a prerecorded
% signal
%[in,fs] = audioread('EECSsubmission.wav');

% Capture 5 second audio clip
e = audiorecorder(Fs, 16, 1);
recordblocking(e,5);
in = getaudiodata(e, 'double');

% Reduce noise in impulse
for i = 1:size(impulse)
    if abs(impulse(i)) < 0.007
       impulse(i) = 0;
    end
end
% Convolve signal
convd = conv(in, impulse);
% Normalize if necessary
high = max(abs(convd));
if high > 1
convd = convd ./ high;
end

% Output block

sound(convd, 48000);
disp('Here is your new sound!');
pause(1);
% If you want to plot output
%  plot(t,convd, 'y');
%  title('Convolution effect on Audio');
%  xlabel('Time (Seconds)');
%  ylabel('Amplitude');
end