TX_FFT_Image  reads in image file, reshapes to 200x200 image size.

then add chirps signals for start sync and picture line sync.

file is saved as audio wave file fs = 12khz.

this audio file can feed into am or fm transmitters.
or just audio over speakers.

RX_FFT_Image reads in wave file from a recording and creates the image again.

a fft version of narrow band tv or slow scan tv.

tx time is around 20seconds,  so not too long for transmitting.

the image is converted to a pattern of sine waves who's intensity changes with the intensity of the picture.

try sending the audio over the air and have a sdr decode it .

from limited testing works well with am or fm.

fm leads to be the best, especially when wide fm is used.

but standard 10khz bw am modulation is good as well..
