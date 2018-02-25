function [offset] = bit_phase_det (fS, fD, y, bPlot);
  % bit_phase_det detects the bitphase of an FSK modulated 
  %   input signal y sampled with fS and a data rate of fD
  % @var{fS} - sample frequency
  % @var{fD} - data rate
  % @var{y} - demodulated signal

  % Prepare reference square wave signal
  t = (1/fS)*(1:length(y)); 
  
  yPulse = sign(abs(sign(y(1:end-1)) - sign(y(2:end))));
  
  yRec = yPulse(1:end-fS/fD/2);

  for i=1:fS/fD/2
    yRec += yPulse(i+1:end-fS/fD/2+i);
  end
  
  yRec = (sign (yRec - 0.1) + 1) ./2;
  x = square(2*pi*t.'*fD);
  [M, offset] = max (xcorr (sign(yRec), x, fS/fD) );
  offset = fS/fD - mod (offset, fS/fD);
  
  if (bPlot)
    yRec = [yRec; zeros(100,1)];
    len = length (y) - offset;
    
    figure
    plot ( t(1:len),[y(1:len),0.01+yRec(1:len),0.01+x(offset:len+offset-1)])
    legend ('y', 'y-impulses', 'bit clk - sample with raising edge');
    grid minor
  end


end
