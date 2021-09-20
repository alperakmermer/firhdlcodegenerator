q = quantizer('fixed','floor','saturate',[16 14]);
clear mlhdlc_2_phase24_tap_filter;

Ts = 10e-6; % örnekleme periyodu 10 us, fs=100KHz
fNy = 1 / Ts / 2; % Nyquist frekansi
ns = 1000; % dizideki örnek sayisi
nf = 10; % dizide kaç farkli frekansta isaret olacagi


for i = 1:ns
freq(i) = (fNy/ns) * round(i/ns*nf)*ns/nf; % orneklerin frekansi
end

for i = 1:ns
x(i) = cos(2*pi*freq(i)*Ts*i);
end

x_in=num2hex(q,x);
x_in=hex2num(q,x_in);

x0 = x_in(1:2:end);
x1 = x_in(2:2:end);
len = length(x)/2;
y0  =zeros(1,len);
y1  =zeros(1,len);
y_out=zeros(1,2*len);

%% 16 bit 14 fraction


h_24=[0.00323486328125,0.0133056640625,0.01702880859375,-0.00274658203125,-0.025146484375,-0.0032958984375,0.04248046875,0.018798828125,-0.07354736328125,-0.06146240234375,0.1669921875,0.426513671875,0.426513671875,0.1669921875,-0.06146240234375,-0.07354736328125,0.018798828125,0.04248046875,-0.0032958984375,-0.025146484375,-0.00274658203125,0.01702880859375,0.0133056640625,0.00323486328125];
%h_48=[0.0001220703125,0.00042724609375,0.0003662109375,-0.0006103515625,-0.00103759765625,0.00091552734375,0.0023193359375,-0.00103759765625,-0.00445556640625,0.000732421875,0.00775146484375,0.0003662109375,-0.01251220703125,-0.00274658203125,0.0191650390625,0.00732421875,-0.02862548828125,-0.0157470703125,0.04315185546875,0.0322265625,-0.0703125,-0.07421875,0.1597900390625,0.4371337890625,0.4371337890625,0.1597900390625,-0.07421875,-0.0703125,0.03222656250,0.0431518554687500,-0.0157470703125,-0.02862548828125,0.00732421875,0.0191650390625,-0.00274658203125,-0.01251220703125,0.0003662109375,0.00775146484375,0.000732421875,-0.00445556640625,-0.00103759765625,0.0023193359375,0.00091552734375,-0.00103759765625,-0.0006103515625,0.0003662109375,0.00042724609375,0.0001220703125];


for ii=1:len
    % call to the design 'mlhdlc_sfir' that is targeted for hardware
    [y0(ii),y1(ii)] = mlhdlc_2_phase_symmetric_24_tap_filter(x0(ii),x1(ii),h_24(1),h_24(2),h_24(3),h_24(4),h_24(5),h_24(6),h_24(7),h_24(8),h_24(9),h_24(10),h_24(11),h_24(12));
end

for i=0 : (length(y0)-1)
    y_out(2*i+1) = y0(i+1);
    y_out(2*i+2) = y1(i+1);
end

y_orj = conv(x_in,h_24);

figure;
subplot(3,2,1);
plot(x_in);
title("original signal");
spec = abs(fft(x_in));
subplot(3,2,2);
plot((0:100:50e3-100),spec(1:ns/2));
title("original signal in frequency domain");

subplot(3,2,3);
plot(y_orj);
title("reference filtered signal");
spec1 = abs(fft(y_orj));
subplot(3,2,4);
plot((0:100:50e3-100),spec1(1:ns/2));
title("reference filtered signal in frequency domain");

subplot(3,2,5);
plot(y_out);
title("signal filtered with T&C");
spec2 = abs(fft(y_out));
subplot(3,2,6);
plot((0:100:50e3-100),spec2(1:ns/2));
title("signal filtered with T&C in frequency domain");