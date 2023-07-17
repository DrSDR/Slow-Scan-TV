
clear;
clc;
[filename, pathname, filterindex] = uigetfile('*.*','Pick a Image file','c:\FFT_Image');
g = 100;

pathname = [pathname filename];
data = imread(pathname);
data = imresize(data,[200 200] );
data = rgb2gray(data);
data = double(data);
data = data / max(data(:));

[hpixels,wpixels] = size(data);
w = 15*randn(hpixels,wpixels);
w = exp(1i*w);
data = data .* w;
data = [zeros(hpixels,g) data zeros(hpixels,g)];
d1 = data(:,end:-1:2);
d1 = conj(d1);
data = [d1 data];

data = ifftshift(data,2);
data = ifft(data,[],2);

data = data / max(abs(data(:)));

fs = 12e3;  % sample rate of ofdm signal 
% create chirp signal for sync 
N = 8000;  %number of samples for chirp sync pulse
t = [0:(N-1)]/fs;
f0 = 300;
f1 = 3000;
T = N/fs;
c = (f1 - f0)/T;
x = (c/2)*t.^2 + f0*t;
pream = sin(2*pi*x);
preamble = pream / max(pream);



N = 128;  %number of samples for chirp sync pulse
t = [0:(N-1)]/fs;
f0 = 3000;
f1 = 500;
T = N/fs;
c = (f1 - f0)/T;
x = (c/2)*t.^2 + f0*t;
sync = sin(2*pi*x);
sync = sync / max(sync);



chirpstack = repmat(sync,hpixels,1);
data = [chirpstack data];
data = reshape(data.',1,[]);
data = data / max( abs(data));

data = [preamble data];


[filename, pathname] = uiputfile('*.wav','Save WAVE File');

pathname = [pathname filename];
%pathname = 'c:\SDR_Work\fft_image_audio.wav';

delay = 5;
dN = round(delay * fs);
dN = zeros(1,dN);
data = [dN data dN];
% hlpf = fir1(24,0.9);
% data = filter(hlpf,1,data);
data = data / max(abs(data));
data = [real(data)'  ];
audiowrite(pathname,data,fs);





% %  make the .dat file  float32 of IQIQIQIQIQ...
% datafile = [ real(data) ; imag(data) ];
% 
% datafile = reshape(datafile, 1, []);
% 
% [filename pathname ] = uiputfile( '.dat', 'Save FCM .dat File To:  ');
% 
% fid = fopen ([pathname filename], 'w', 'b');
% 
% fwrite(fid, datafile, 'float32');
% 
% fclose (fid);
% 

