## @var{y} - bit sequence


function [symbol, prob] = detect_sym (y, yFull);

  % saturation of the input value
  y (y>yFull) = yFull;
  y (y<(-yFull)) = -yFull;

  % we add another column with the optimal value of all the others
  
  A=y.';
  %from: https://de.mathworks.com/matlabcentral/answers/137188-how-can-i-return-the-signed-maximum-absolute-value-of-each-column-of-a-matrix
  [~,index] = max(abs(A));
  opt = (A(sub2ind(size(A),index,1:size(A,2)))).';
  y = [y, opt]
  
  
  data = [];
  pData = [];
  
  for i=1:size(y)(2)
    symbol = sign (y(:,i));
    % handle the unlikely case of y=0
    symbol(abs(symbol)<1) = 1;

    % do the symbol decoding
    [sym, ok] = decode_sym(symbol);

    data = [ data; sym];

    symP = calc_symbol_prob(symbol, y(:,i), yFull, ok);
    pData = [pData; symP];
    
    % now let us follow some permutations of those values here
    [_, candidate] = sort(abs(y(:,i)));
    for j=1:7
      mutatorIdx = de2bi(j);
      mutatorIdx (length(candidate)) = 0;
      mutatorIdx = (mutatorIdx.').*candidate;
      mutator = ones(length(candidate),1);
      for k=1:length(candidate)
        if (mutatorIdx(k) > 0)
          mutator(mutatorIdx(k)) = -1;
        end
      end
      mutatedSymbol = mutator.*symbol;
      [sym, ok] = decode_sym (mutatedSymbol);
      data = [data; sym];
      symP = calc_symbol_prob(mutatedSymbol, y(:,i), yFull, ok);
      pData = [pData; symP];
    end
  end
  [prob, I] = sort (pData, 'descend');
  prob = prob(1:16);
  symbol = data(I)(1:16);
end

function prob = calc_symbol_prob (symbol, y, yFull, crcOK);
  % prop for wrong created CRC
  pWrongCRC = 0.01;
  
  pBits = 1-abs(symbol.-(y./yFull))/2;
  pData = prod(pBits(1:7));
  pCRC = prod(pBits(8:10));
  if (crcOK) 
    pData.*= pCRC;
  else
    pData.*= pWrongCRC;
  end
  prob = pData;
end