function FM(Fs)
% The line below is used if you want to use this fcn with a prerecorded
% signal
%[x,Fs] = audioread('EECSsubmission.wav');

% Capture 5 second audio clip
s = audiorecorder(Fs, 16, 1);
len = 5;
recordblocking(s,len);
x = getaudiodata(s, 'double');

% Frequency Modulation logic
fc = 100;
fDev = 99;
t = linspace(1,3,length(x));
y = fmmod(x,fc,Fs,fDev);

% DFT taken to see frequency of speech
xf = fft(x);
L = length(x);
P2 = abs(x/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L-1))/L;
%plot(f, P2);
yf = fft(y);


% Apply filter and gain to signal
y = 750 * filter(FM_filter, y);

% Zero out initial impulse
y(1:91) = 0;

% Output Block
% If you'd like to plot output signal
% plot(t,y, 'y');
% title('Frequency Modulation effect on Audio');
% xlabel('Time (Seconds)');
% ylabel('Amplitude');
disp('Here is your new sound!');
pause(1);
sound(y,Fs);
end

