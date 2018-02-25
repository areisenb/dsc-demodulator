function [symbol, ok] = decode_sym (d);
  parity = 0;
  parityBits = 0;
  symbol = 0;
  for i=1:7
    symbol *= 2;
    if (d(8-i) == 1)
      symbol += 1;
    else
      parity += 1;
    end
  end

  for i=8:10
    parityBits *= 2;
    if (d(i) == 1)
      parityBits += 1;
    end
  end

  %d.'
  %disp([' symbol: ',num2str(symbol),' parity: ', num2str(parity), ' parBits: ', num2str(parityBits)])
  ok = (parity == parityBits);
end
