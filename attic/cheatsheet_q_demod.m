   Attr Name        Size                     Bytes  Class
   ==== ====        ====                     =====  =====
        Fs          1x1                          8  double
        Nsamps      1x1                          8  double
        a           1x6                         48  double
        ans         1x9                        662  cell
        b           1x6                         48  double
        bits        1x1                          8  double
        f           1x32802                 262416  double
        file        1x29                        29  char
        li      65605x1                     524840  double
        lq      65605x1                     524840  double
        t           1x65605                     24  double
        ui      65605x1                     524840  double
        uq      65605x1                     524840  double
        y       65605x1                     524840  double
        y_fft   32802x1                     262416  double

li=sin(2*pi*t.'*1615);
ui=sin(2*pi*t.'*1785);
lq=cos(2*pi*t.'*1615);
uq=cos(2*pi*t.'*1785);


[b,a]=butter(5,50/8000);

raised cosine should perform much better
https://de.mathworks.com/matlabcentral/fileexchange/44821-matlab-code-for-fsk-modulation-and-demodulation?focused=3805505&tab=function
https://edoras.sdsu.edu/doc/matlab/toolbox/comm/rcosine.html

[b,a]=rcosine (200,8000);
hätte eigentlich erwartet 100,8000 - aber 200 gibt schönere Ergebnisse...
400 gibt noch schönere :-(
aber da gibt es wieder ein Überschwingen - also doch 100

plot (t, [y, filter(b,a,(ui.*y)).^2+filter(b,a,(uq.*y)).^2,filter(b,a,(li.*y)).^2 + filter(b,a,(lq.*y)).^2])

plot (t, [y, filter(b,a,(ui.*y)).^2+filter(b,a,(uq.*y)).^2,filter(b,a,(li.*y)).^2 + filter(b,a,(lq.*y)).^2, filter(b,a,(ui.*y)).^2, filter(b,a,(uq.*y)).^2])
>> legend ('mod','upper', 'lower', 'ui', 'uq')

bits 
204 DX
214 RX-7
224 DX
234 RX-6
244 DX
254 RX-5
264 DX
274 RX-4
284 DX
294 RX-3
304 DX
314 RX-2
324 A 120 0001 111 011
334 RX-1
344 A 120
354 RX-0
364 B1 00 0000 000 111
374 A 120
384 B2 23 1110 100 011
394 A 120

