% read the  iq wave file
% [filename, pathname, filterindex] = uigetfile('*.*','Pick a FSK IQ wave file','c:\FSK4Level\');
clear all;
close all;
clc;

plotstuff = 0;


fs = 12e3;

[filename, pathname, filterindex] = uigetfile('*.wav','Pick a Image IQ wave file','C:\sdr#\sdrsharp-x86-noskin(1)\');

pathname = [pathname filename];
[message,fswave] = audioread(pathname);
[audiosamples,nch] = size(message);

message = message(:,1);
message = message.';




if fswave ~= fs
    
    x = gcd(fswave,fs);
    a = fs/x;
    b = fswave/x;
    message = resample(message,a,b);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enter in expected image dim details
%image pixels height and width
h = 200;
w = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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





h1 = conj(sync(end:-1:1));
h1N = length(h1);
h2 = conj(preamble(end:-1:1));
h2N = length(h2);


%find preamble
h2detect = filter(h2,1,message);
[Imax, index] = max(abs(h2detect));
index = index + 1;
data = message(index:end);
Ndata = length(data);

pic = zeros(h,w);
pictime = zeros(h,w);

fftN = 2*(w+200) - 1;

x1 = 1;
x2 = fftN + h1N;

for k = 1:h
    
    if x1 >= Ndata || x2 >= Ndata
        break
    end
    
    iqk = data(x1:x2);
    syncdet = filter(h1,1,iqk);
    if plotstuff
        figure(2345)
        plot(abs(syncdet))
    end
    [imax,index] = max(abs(syncdet));
    
    a = index + 1;
    
    iqpic = iqk(a:end);
   %  pictime(k,:) = 20*log10(abs(iqpic(1:w)));
    iqpic = fft(iqpic,fftN);
    if plotstuff
        figure(5432)
        plot(abs(iqpic))
        pause(0.1);
    end

    iqpic = iqpic(1:w+200);
    iqpic = abs(iqpic);
    iqpic = iqpic(101:end);
    pic(k,:) = iqpic(1:w);
    x1 = x1 + index + fftN;
    x2 = x1 + fftN + h1N;
   
    
end


% figure(22)
% colormap('jet')
% set(22,'Position',[50,600,w,h]);
% imagesc(pictime);
w = 2*w;
h = 2*h;

figure(23)
colormap('bone')
set(23, 'Position',[50,50,w,h]);
imagesc(-1 * pic)

    
    

figure(24)
colormap('gray')
set(24, 'Position',[600,50,w,h]);
imagesc(pic)



figure(25)
colormap('bone')
set(23, 'Position',[800,50,w,h]);
imagesc( pic)









