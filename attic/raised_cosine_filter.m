%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creative Commons
% Attribution-Noncommercial 2.5 India
% You are free:
% to Share — to copy, distribute and transmit the work
% to Remix — to adapt the work
% Under the following conditions:
% Attribution. You must attribute the work in the manner 
% specified by the author or licensor (but not in any way 
% that suggests that they endorse you or your use of the work). 
% Noncommercial. You may not use this work for commercial purposes. 
% For any reuse or distribution, you must make clear to others the 
% license terms of this work. The best way to do this is with a 
% link to this web page.
% Any of the above conditions can be waived if you get permission 
% from the copyright holder.
% Nothing in this license impairs or restricts the author's moral rights.
% http://creativecommons.org/licenses/by-nc/2.5/in/

% Checked for proper operation with Octave Version 3.0.0
% Author	: Krishna
% Email		: krishna@dsplog.com
% Version	: 1.1
% Date		: 25 May 2008
% Details	: Corrected the division by zero error
% Version	: 1.0
% Date		: 21 April 2008
% Details	: First release
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script for plotting the time domain and frequency domain representation
% of raised cosine filters for various values of alpha

clear all
fs = 10;

% defining the sinc filter
sincNum = sin(pi*[-fs:1/fs:fs]); % numerator of the sinc function
sincDen = (pi*[-fs:1/fs:fs]); % denominator of the sinc function
sincDenZero = find(abs(sincDen) < 10^-10);
sincOp = sincNum./sincDen;
sincOp(sincDenZero) = 1; % sin(pix/(pix) =1 for x =0

alpha = 0;
cosNum = cos(alpha*pi*[-fs:1/fs:fs]);
cosDen = (1-(2*alpha*[-fs:1/fs:fs]).^2);
cosDenZero = find(abs(cosDen)<10^-10);
cosOp = cosNum./cosDen;
cosOp(cosDenZero) = pi/4;
gt_alpha0 = sincOp.*cosOp;
GF_alpha0 = fft(gt_alpha0,1024);

alpha = 0.5;
cosNum = cos(alpha*pi*[-fs:1/fs:fs]);
cosDen = (1-(2*alpha*[-fs:1/fs:fs]).^2);
cosDenZero = find(abs(cosDen)<10^-10);
cosOp = cosNum./cosDen;
cosOp(cosDenZero) = pi/4;
gt_alpha5 = sincOp.*cosOp;
GF_alpha5 = fft(gt_alpha5,1024);

alpha = 1;
cosNum = cos(alpha*pi*[-fs:1/fs:fs]);
cosDen = (1-(2*alpha*[-fs:1/fs:fs]).^2);
cosDenZero = find(abs(cosDen)<10^-10);
cosOp = cosNum./cosDen;
cosOp(cosDenZero) = pi/4;
gt_alpha1 = sincOp.*cosOp;
GF_alpha1 = fft(gt_alpha1,1024);

close all
figure
plot([-fs:1/fs:fs],[gt_alpha0],'b','LineWidth',2)
hold on
plot([-fs:1/fs:fs],[gt_alpha5],'m','LineWidth',2)
plot([-fs:1/fs:fs],[gt_alpha1],'c','LineWidth',2)
legend('alpha=0','alpha=0.5','alpha=1');
grid on
xlabel('time, t')
ylabel('amplitude, g(t)')
title('Time domain waveform of raised cosine pulse shaping filters')

figure
plot([-512:511]/1024*fs, abs(fftshift(GF_alpha0)),'b','LineWidth',2);
hold on
plot([-512:511]/1024*fs, abs(fftshift(GF_alpha5)),'m','LineWidth',2);

plot([-512:511]/1024*fs, abs(fftshift(GF_alpha1)),'c','LineWidth',2);
legend('alpha=0','alpha=0.5','alpha=1');
axis([-2 2 0 14])
grid on
xlabel('frequency, f')
ylabel('amplitude, |G(f)|')
title('Frequency domain representation of raised cosine pulse shaping filters')
