function [upper, lower] = q_demod (fS, f0, fT, fD, y);
  % q_demod quadratur demodulator 
  % @var{fS} - sample frequency
  % @var{f0} - center frequency of the FSK
  % @var{fT} - frequency deviation
  % @var{fD} - data rate
  % @var{y} - modulated signal

  t = (1/fS)*(1:length(y));          %Prepare time series

  li=sin(2*pi*t.'*(f0-fT)); % lower frequ. I-phase
  ui=sin(2*pi*t.'*(f0+fT)); % upper frequ. I-phase
  lq=cos(2*pi*t.'*(f0-fT)); % lower frequ. Q-phase
  uq=cos(2*pi*t.'*(f0+fT)); % upper frequ. Q-phase

  [b,a]=rcosine (fD,fS); % raised cosine filter

  upper = filter(b,a,(ui.*y)).^2 + filter(b,a,(uq.*y)).^2;
  lower = filter(b,a,(li.*y)).^2 + filter(b,a,(lq.*y)).^2;

end
