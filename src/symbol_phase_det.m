function [offset] = symbol_phase_det (y);
  % symbol_phase_det detects the phase of the DSC message
  %   of the bitsymbols as input y
  % @var{y} - input bit sequence

  % sync pattern DX RX7 DX RX6 DX RX5 DX RX4 DX RX3 DX RX2 A RX1 A RX0
  % DX   125 = YBYYYYYBBY ==> 1011111001
  % RX-0 104 = BBBYBYYYBB ==> 0001011100
  % RX-1 105 = YBBYBYYBYY ==> 1001011011
  % RX-2 106 = BYBYBYYBYY ==> 0101011011
  % RX-3 107 = YYBYBYYBYB ==> 1101011010
  % RX-4 108 = BBYYBYYBYY ==> 0011011011
  % RX-5 109 = YBYYBYYBYB ==> 1011011010
  % RX-6 110 = BYYYBYYBYB ==> 0111011010
  % RX-7 111 = YYYYBYYBBY ==> 1111011001

  symDot = [ 1 0 1 0 1 0 1 0 1 0 ];
  symDX  = [ 1 0 1 1 1 1 1 0 0 1 ];
  symRX0 = [ 0 0 0 1 0 1 1 1 0 0 ];
  symRX1 = [ 1 0 0 1 0 1 1 0 1 1 ];
  symRX2 = [ 0 1 0 1 0 1 1 0 1 1 ];
  symRX3 = [ 1 1 0 1 0 1 1 0 1 0 ];
  symRX4 = [ 0 0 1 1 0 1 1 0 1 1 ];
  symRX5 = [ 1 0 1 1 0 1 1 0 1 0 ];
  symRX6 = [ 0 1 1 1 0 1 1 0 1 0 ];
  symRX7 = [ 1 1 1 1 0 1 1 0 0 1 ];
  symDum = [ 1 1 1 1 1 1 1 0 0 0 ];

  symP = [ symDot, symDot, ...
           symDX, symRX7, symDX, symRX6, symDX, symRX5, symDX, symRX4, ...
           symDX, symRX3, symDX, symRX2, symDum, symRX1, symDum, symRX0 ];

  [m,i] = max (xcorr((symP-0.5).*2, y));
  offset = length(y)-i + 1 + ...
    2*length(symDot) + ... for the 2 DOT patterns we have in
    12*length(symDX); ... for the 6 DX and RX-7 to RX-2

end
