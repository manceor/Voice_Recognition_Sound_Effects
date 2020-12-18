%% Main 2
% All commented code at the bottom was previous iterations/code to
% reference
%Load trainer signals and take first channel
function project
clear;
clc;
[Sound, ~] = audioread('mod.wav');
one1 = Sound(:,1);

[Sound, ~] = audioread('mod2.wav');
one2 = Sound(:,1);

[Sound, ~] = audioread('mod3.wav');
one3 = Sound(:,1);

[Sound, ~] = audioread('echo.wav');
two1 = Sound(:,1);

[Sound, ~] = audioread('echo2.wav');
two2 = Sound(:,1);

[Sound, ~] = audioread('echo3.wav');
two3 = Sound(:,1);

[Sound, ~] = audioread('convolution.wav');
three1 = Sound(:,1);


[Sound, ~] = audioread('convolution2.wav');
three2 = Sound(:,1);


[Sound, Fs] = audioread('convolution3.wav');
three3 = Sound(:,1);

%Begin text to user to inform and direct
disp('Welcome to the Smart Audio Effects Processor!');
pause(2);

disp('When prompted, you will say one of three cues for an audio effect. These are...');
disp('mod for frequency modulation (alien voice)');
disp('echo for echo');
disp('convolution for a "Through-a-door effect"');
while (1)
    
% Press button to begin selection mode
effect = input('Press any key followed by enter to say a command or type quit to leave: ', 's');
% Exit the function
if (strcmp(effect, 'quit'))
    disp('Thanks for trying my effects processor!');
    return;
end
x = 0;
while x == 0
clear r sel st I
disp('Say the queue of the effect you would like to hear');
% Begin recording user cue
r = audiorecorder(48000, 16, 1);
recordblocking(r,3);
test = getaudiodata(r, 'double');
 
%Calculate MFCC and normalize
oneCo1 = mfcc(one1,Fs);
oneCo1 = (oneCo1 - mean(oneCo1)) ./ std(oneCo1);
oneCo2 = mfcc(one2,Fs);
oneCo2 = (oneCo2 - mean(oneCo2)) ./ std(oneCo2);
oneCo3 = mfcc(one3,Fs);
oneCo3 = (oneCo3 - mean(oneCo3)) ./ std(oneCo3);
twoCo1 = mfcc(two1,Fs);
twoCo1 = (twoCo1 - mean(twoCo1)) ./ std(twoCo1);
twoCo2 = mfcc(two2,Fs);
twoCo2 = (twoCo2 - mean(twoCo2)) ./ std(twoCo2);
twoCo3 = mfcc(two3,Fs);
twoCo3 = (twoCo3 - mean(twoCo3)) ./ std(twoCo3);
threeCo1 = mfcc(three1,Fs);
threeCo1 = (threeCo1 - mean(threeCo1)) ./ std(threeCo1);
threeCo2 = mfcc(three2,Fs);
threeCo2 = (threeCo2 - mean(threeCo2)) ./ std(threeCo2);
threeCo3 = mfcc(three3,Fs);
threeCo3 = (threeCo3 - mean(threeCo3)) ./ std(threeCo3);
testCo = mfcc(test,Fs);
testCo = (testCo - mean(testCo)) ./ std(testCo);


%Perform DTW comparions on MFCC vectors
Isone1 = dtw(oneCo1, testCo);
Isone2 = dtw(oneCo2, testCo);
Isone3 = dtw(oneCo3, testCo);

Istwo1 = dtw(twoCo1, testCo);
Istwo2 = dtw(twoCo2, testCo);
Istwo3 = dtw(twoCo3, testCo);

Isthree1 = dtw(threeCo1, testCo);
Isthree2 = dtw(threeCo2, testCo);
Isthree3 = dtw(threeCo3, testCo);

% Find norms of difference of MFCC vectors (Unused)
oneeig1 = norm(oneCo1 - testCo);
oneeig2 = norm(oneCo2 - testCo);
oneeig3 = norm(oneCo3 - testCo);
 
twoeig1 = norm(twoCo1 - testCo);
twoeig2 = norm(twoCo2 - testCo);
twoeig3 = norm(twoCo3 - testCo);
 
threeeig1 = norm(threeCo1 - testCo);
threeeig2 = norm(threeCo2 - testCo);
threeeig3 = norm(threeCo3 - testCo);

% Insert DTW comparisons into array
modarray = [Isone1, Isone2, Isone3];
echoarray = [Istwo1, Istwo2, Istwo3];
convarray = [Isthree1, Isthree2, Isthree3];


% Make a total DTW array and sort
distWords = sort([Isone1, Isone2, Isone3, Istwo1, Istwo2, Istwo3, Isthree1, Isthree2, Isthree3]);

% Checks if any array has two of lowest threee total distances
if sum(ismember(modarray,distWords(1:3))) > 1 
    disp('You selected effect one: Frequency Modulation, speak now!')
    x = 1;
    FM(Fs);
elseif sum(ismember(echoarray, distWords(1:3))) > 1
    disp('You selected effect two: Echo, speak now!')
    x = 1;
    echoed(Fs);
elseif sum(ismember(convarray, distWords(1:3))) > 1
    disp('You selected effect three: Convolution, speak now!')
    x = 1;
    convolution(Fs);
    
% If not, redo test
else
    disp('Unrecognized Word, Please Repeat')
end


end

end
end


% %% 1 & 2 PSD
% clear;
% [one,Fs] = audioread('1.wav');
% %sound(y,Fs);
%  one = one(:,1);
%     sy = spectrogram(one, [], [], [],'psd');
%     figure(1);
%     spectrogram(one,[], [], [],'psd');
%     sy = real(sy);
%     sy = sy(:,1:2);
%     gy = fitgmdist(sy,1);
%     %pyulear(y,24,512, 8000);
%     %periodogram(y);
%     
%     
% [two,Fs] = audioread('3.wav');
% sound(two,Fs);
% 
%  two = two(:,1);
%     sx = spectrogram(two,[], [], [],'psd');
%     figure(2);
%     spectrogram(two, [], [], [],'psd');
%     sx = real(sx);
%    sx = sx(:,1:2);
%     gx = fitgmdist(sx,1);
%     
% [three,Fs] = audioread('9.wav');
% sound(three,Fs);
% 
%  three = three(:,1);
%     dt = 1/Fs;
%     sz = spectrogram(three,[], [], [],'psd');
%     figure(3);
%     spectrogram(three,[], [], [],'psd');
%     sz = real(sz);
%     sz = sz(:,1:2);
%     gz = fitgmdist(sz,1);
%     
%     %pyulear(x,12,512,8000);
%     %periodogram(x);
% %audiorecorder/recordblocking for live audio    
%  
%% Input
 
% effect = input('Please select an effect(choices are echo, mod, and distortion): ', 's');
% disp('effect selected: modulation');
% disp('Begin audio now!');

% %% Main
% clear;
% [one,Fs] = audioread('1.wav');
%  one = one(:,1);
%     sy = spectrogram(one, [], [], [],'power');
%     sy = real(sy);
%     %sy = sy(:,1:2);
%     gy = fitgmdist(sy,1);
%     %pyulear(y,24,512, 8000);
%     %periodogram(y);
%     
%     
% [two,Fs] = audioread('2.wav');
% 
%  two = two(:,1);
%     sx = spectrogram(two,[], [], [],'power');
%     sx = real(sx);
%    sx = sx(:,1:2);
%     gx = fitgmdist(sx,1);
%     
% [three,Fs] = audioread('3.wav');
% 
%  three = three(:,1);
%     dt = 1/Fs;
%     sz = spectrogram(three,[], [], [],'power');
%     sz = real(sz);
%     sz = sz(:,1:2);
%     gz = fitgmdist(sz,1);
%     
%     %pyulear(x,12,512,8000);
%     %periodogram(x);
% %audiorecorder/recordblocking for live audio 
% effect = input('Press any button to begin: ', 's');
% if (effect)
% x = 0;
% while x == 0
% clear r sel st I
% disp('Say effect number that you want to use: (1 mod, 2 echo, 3 conv)');
% r = audiorecorder(48000, 16, 1);
% recordblocking(r,3);
% sel = getaudiodata(r, 'double');
% 
% st = spectrogram(sel, 'yaxis', [], [], []);
% st = real(st);
% st = st(:,1:2);
% [Y,ll1] = posterior(gy,st);
% [X,ll2] = posterior(gx,st);
% [Z,ll3] = posterior(gz,st);
% [M,I] = max([ll1,ll2,ll3]);
% ring = ['You selected effect ' ,num2str(I),', is this correct? '];
% decision = input(ring, 's');
% if strcmp(decision, 'yes')
%     x = 1;
%     I = 2;
% end
% end
% if I == 1
%     disp('Performing effect: Frequency Modulation. Go ahead and talk!')
%     FreqMod(Fs);
% end
% if I == 2
%     disp('Performing effect: Echo. Go ahead and talk!')
%     echoed(Fs);
% end
% if I == 3
%     disp('Performing effect: Convolution. Go ahead and talk!')
%     Co(fs);
% end
% end

