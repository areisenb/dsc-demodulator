
clear
pkg load communications

% constants
file = '../testdata/trimmed_mf_DSC.wav';
f0 = 1700;
fT = 85;
fD = 100; ## 100 Baud
yFull = 0.05; % full signal

inputDSC = [120, 0, 23, 20, 0, 10, 100, 0, 50, 30, 0, 10, 109, 126, 8, 29, 10, 8, 29, 10, 117, 85, 117, 117];


%Load File 
[y,fS,bits] = wavread(file);
y = y(1:end);

Nsamps = length(y); 
t = (1/fS)*(1:Nsamps);          %Prepare time data for plot
%t=1:Nsamps;

yRef = y;
y = awgn (y, -3);


[BRef, YRef] = q_demod (fS, f0, fT, fD, yRef);
[B, Y] = q_demod (fS, f0, fT, fD, y);
## upper => B = 0
## lower => Y = 1

shiftBitClock = bit_phase_det(fS, fD, Y-B, 0)

dRaw = (Y-B)((fS/fD-shiftBitClock):fS/fD:end);
dRawUp = upsample (dRaw, fS/fD, fS/fD-shiftBitClock)(1:length(t));

shiftSymClock = symbol_phase_det (dRaw);

d = (sign (dRaw)(shiftSymClock:end).+1)./2;

dUp = [zeros(shiftSymClock-1,1); d];
dUp = upsample (dUp-0.5, fS/fD, fS/fD-shiftBitClock)(1:length(t));


symClock = zeros (length(d), 1);
symClock(1:10:end) = 1;

symClockUp = [zeros(shiftSymClock-1,1); symClock];
symClockUp = upsample (symClockUp, fS/fD, fS/fD-shiftBitClock)(1:length(t));

dSamp = dRaw(shiftSymClock:end);


figure
plot (t, [YRef-BRef, sign(YRef-BRef)*0.35], '--',
      t, [Y-B, sign(Y-B)*0.3], '-',
      t, [Y, -B], '-.',
      t, dRawUp,
      t, dUp,
      t, symClockUp*0.4, 'k');
legend ('ref demod', 'ref det', 'demod (=Y-B)', 'det', ...
  'Y', 'B', 'sampled bits', 'sampled symb', 'symb clock');
grid minor


return


data = [];
msg = [];
ok = [];
msg1 = [];
ok1 = [];
dsc = [];
dscProb = [];
symbol = [];

for i=1:20:length(d)
  if ((i+9) <= length(d))
    [actMsg, actOK] = decode_sym(d(i:(i+9)));
  end
  msg = [msg, actMsg];
  ok = [ok, actOK];
  if ((i+59) <= length(d))
    [actMsg, actOK] = decode_sym(d((i+50):(i+59)));
    msg1 = [msg1, actMsg];
    ok1 = [ok1, actOK];
  else
    msg1 = [msg1, 117];
    ok1 = [ok1, 1];
  end
  
  %% evaluate array of symbols (2 in general, 4 for format specifier
  if (i!=21)
    % we have treated this already as part of symbol 1
    % symbol = dSamp (i:(i+9));
    if ((i+59) <= length (dSamp))
      symbol = [symbol, dSamp((i+50):(i+59))];
    else
      if ((i+50) <= length (dSamp))
        symbol = [symbol, [dSamp((i+50):length(dSamp));zeros(i+59-length(dSamp),1)]];
      else 
        symbol = [symbol, zeros(10,1)];
      end
    end
    if (i==1)
      symbol = [symbol, dSamp((i+20):(i+29)), dSamp((i+70):(i+79))];
    end
    [dscBit, dscBitProb] = detect_sym(symbol, yFull);
    dsc = [dsc, dscBit];
    dscProb = [dscProb, dscBitProb];
  end
end

data = [ msg; ok; msg1; ok1 ]
dsc
dscProb = round(dscProb.*100)
inputDSC

figure
scatter (p, Y-B);
figure
plot (t(shiftBitClock:fS/fD:end), dRaw);

#legend ('upper', 'lower');
