function echoed(fs)
% The line below is used if you want to use this fcn with a prerecorded
% signal
%[in,fs] = audioread('EECSsubmission.wav');

% Capture 5 second audio clip
e = audiorecorder(fs, 16, 1);
recordblocking(e,5);
in = getaudiodata(e, 'double');

% Echo parameters
num_echo = 5;
delay = 0.3;
gain = 0.15;

for i = 1:num_echo
    
samples = round(fs*delay);
ds = floor(samples);
% Add zeros for echoed signal
signal = zeros(length(in)+ds,1);
% Copy signal
echo_signal = signal;
signal(1:length(in)) = in(:,1);
% Add copied signal to output with delay and gain
echo_signal(ds+(1:length(in*gain)))=in(:,1)*gain;
output = signal + echo_signal;

% Normalize if necessary
high = max(abs(output));
if high > 1
output=output ./ high;
end
in = output;
end

%Output block

disp('Here is your new sound!');
pause(1);
% If you want to plot output
% t = linspace(1,5, length(output));
% plot(t, output);
% title('Reverb effect on Audio');
% xlabel('Time (Seconds)');
% ylabel('Amplitude');
sound(output,fs);
end
