%{
        BAND EQUALIZATION OF AN INPUT SIGNAL(.wav SOUND FILE)
                BY SANJEEV SUBRAHMANIYAN(EE23B102)

INPUTS:
NONE. TYPE IN YOUR FILENAME IN THE AUDIOREAD FUNCTION AND ENSURE IT BELONGS
IN THE SAME DIRECTORY AS THIS PROGRAM

OUTPUTS;
WRITES TO A NEW AUDIOFILE CALLED 'outputaudio.wav' IN THE SAME DIRECTORY

IDEATION: 
The idea is to read the file into an array and perform the fourier
transform on the signal to recover the different frequency components.
Because the input signal is a real audio, it is made symmetric using the
fftshift function. Then the respective bands are scaled and inverse fourier
transformed to write into the output file.

%}

%The first step is to read the audiofile(mono) into a matlab array containing the
%values at different points in y and the sampling frequency in Fs. If it is
%a stereo file, the two components must be averaged before this program.

[y, Fs] = audioread("guitartune.wav"); %replace this with the required input file's name which is in the same directory

fprintf(1, "The sampling rate is %d Hz and hence the maximum frequency in the wave is %d Hz", Fs, Fs/2)

if size(y, 2) == 2
    y = sum(y, 2) / 2; 
end

%An array containing a number of points is created to make a plot of the
%audio file as a function of the time it runs through

t = linspace(0, (length(y)-1)/Fs, length(y));
%plot(t, y);

%Creating the fourier transform of the signal which plots the magnitude of
%different frequency components in the signal

n = length(y); % Length of the signal
Y = fft(y); % Compute the Fourier transform
f = (-n/2:n/2-1)*(Fs/n); % Frequency range

Y = fftshift(Y); %Shifting the centre of the fft to zero for symmetric real signals

%Plotting and playing the original audio file

plot(t, y);
title("Amplitude vs time of the original audio")
xlabel("Time")
ylabel("Amplitude")

sound(y, Fs);

pause((length(y)-1)/Fs) %Waiting for the audio to play before showing the next plot

% Initializing the scaled FFT
Yprime = Y;

%Plotting the fft of the signal to give the user an idea of which bands to
%tweak

plot(f, abs(Y));
title('Fourier transform of original audio');
xlabel("Frequency component")
ylabel("Modulus of the component")

%Initialization of the different bands' array
bands = {'0Hz-300Hz', '300Hz-1KHz', '1KHz-3KHz', '3KHz-8KHz', '8KHz-14KHz', '14KHz-20KHz'};
bvals = zeros(1, 6);

%User input for the different bands' amplification
fprintf("Enter the values to which the bands must be scaled to in the ranges 0 to 10 for the respective prompts \n");
for i = 1:6
    bvals(i) = input(['\nEnter the magnitude of scaling for ' bands{i} ' :']);
end


% Scale each band 
for i = 1:numel(bvals)
    %Finding the frequency of different bands
    switch i
        case 1
            f_start = 0;
            f_end = 300;
        case 2
            f_start = 300;
            f_end = 1000;
        case 3
            f_start = 1000;
            f_end = 3000;
        case 4
            f_start = 3000;
            f_end = 8000;
        case 5
            f_start = 8000;
            f_end = 14000;
        case 6
            f_start = 14000;
            f_end = 20000;
    end

    bins = find(abs(f) >= f_start & abs(f) < f_end);
    %Scaling the components in the bins as per the input scaling factors
    Yprime(bins) = Y(bins) * bvals(i);
end

%Plotting the modified sound files
subplot(3,1,1);
plot(f, abs(Y));
title('Fourier transform of original audio');
xlabel("Frequency component")
ylabel("Modulus of the component")

subplot(3,1,2);
plot(f, abs(Yprime));
title('Fourier transform of equalized audio');
xlabel("Frequency component")
ylabel("Modulus of the component")

fvals = linspace(0, 19999, 20000);
b = fvals;

for i = 1:numel(bvals)
    %Finding the frequency of different bands
    switch i
        case 1
            f_start = 0;
            f_end = 300;
        case 2
            f_start = 300;
            f_end = 1000;
        case 3
            f_start = 1000;
            f_end = 3000;
        case 4
            f_start = 3000;
            f_end = 8000;
        case 5
            f_start = 8000;
            f_end = 14000;
        case 6
            f_start = 14000;
            f_end = 20000;
    end

    bins = find(abs(fvals) >= f_start & abs(fvals) < f_end);
    %Scaling the components in the bins as per the input scaling factors]
    b(bins) = bvals(i);
end

subplot(3,1,3);
plot(fvals, b);
title("The input frequency filter chosen by the user");

pause(10);

%Inverse transforming the symmetric fourier transform into a real signal
%which is played and printed into the output file
op = ifftshift(Yprime);
op = ifft(op);
%op
%uncomment the previous line to print the array op
plot(f, op);
sound(op, Fs);
audiowrite('outputaudio.wav', op, Fs);
