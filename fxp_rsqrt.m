
%%Step 1%%%%%%%%%%%%%%%%%%%% SETUP 

w = 30;
f = 17;
%val = 49650.3703460693359375;
x = fi(0, 0, w, f);
x.bin = '111000010101011111010000011010';
fxp_rsqrt2(x);

w = 30;
f = 17;
x = fi(0, 0, w, f);
x.bin = '101101000110000000111101111101';
x.bin;
fxp_rsqrt2(x);

w = 30;
f = 17;
x = fi(0, 0, w, f);
x.bin = '010001110111010011011000011101';
x.bin;
fxp_rsqrt2(x);

w = 30;
f = 17;
x = fi(0, 0, w, f);
x.bin = '101000001111110000011010001011';
x.bin;
fxp_rsqrt2(x);

w = 30;
f = 17;
x = fi(0, 0, w, f);
x.bin = '011111111010100010100011000101';
x.bin;
fxp_rsqrt2(x);

w = 30;
f = 17;
x = fi(0, 0, w, f);
x.bin = '111110100111010101000100101110';
x.bin;
fxp_rsqrt2(x);


w = 30;
f = 17;
x = fi(0, 0, w, f);
x.bin = '100101011000001010010100011011';
x.bin;
fxp_rsqrt2(x);

w = 30;
f = 17;
x = fi(0, 0, w, f);
x.bin = '011100101101011111000001000001';
x.bin;
fxp_rsqrt2(x);

function y = fxp_rsqrt2(x)
   load ROM.mat;  % get the saved ROM table that is in x_beta_table
   rom_lookup = x_beta_table;
   w = x.WordLength;
   f = x.FractionLength;
   Fm = fimath('RoundingMethod','Floor','OverflowAction','Wrap','ProductMode','SpecifyPrecision','ProductWordLength',w,'ProductFractionLength',f,'SumMode','SpecifyPrecision','SumWordLength',w,'SumFractionLength',f);

   x = fi(x.data,0,w,f,Fm);
   
   xbin = x.bin;
   n = 1;
   z = 0;
    while xbin(n) ~= '1'
            n = n + 1;
            z = z + 1;
    end 
    z;
    %Step 2%%%%%%%%%%%%%%%%%%%%% FIND BETA
    b = w - f - z - 1;
    beta = fi(b,1,w,f,Fm);
    
    
    %Step 3%%%%%%%%%%%%%%%%%%%%% FIND ALPHA
    temp = mod(beta.data,2);
    if temp~= 0
        alpha = -bitsll(beta,1)+bitsra(beta,1)+.5;
    else
        alpha = -bitsll(beta,1)+bitsra(beta,1);
    end
    %Step 4%%%%%%%%%%%%%%%%%%%%% FIND XALPHA
    if alpha.data > 0
        xa = bitsll(x, alpha);

    else
        xa = bitsra(x, abs(alpha));
    end 
    xa_decimal = xa.dec;
    xa_binary = xa.bin;
    xa_hex = xa.hex;
    
    %step 5%%%%%%%%%%%%%%%%%%%%% FIND XBETA
    
     if beta.data > 0
        xb = bitsra(x, beta);
     else
        xb = bitsll(x, abs(beta));
     end
     
     
     xb_decimal = xb.data;
     xb_binary = xb.bin;
     xb_hex = xb.hex;

     %step 6%%%%%%%%%%%%%%%%%%%% LOOKUPTABLE

     ad = xb.bin;
     ad(1:13) = [];
     ad(17) = [];
     ad = bin2dec(ad);
     t = fi(ad, 0, f, 0);
     address = int32(t);
     
     bit_string = rom_lookup{address+1}.output_bits;
     bit_half = bit_string(1:18);
     fn = fi(0,0,w,f,Fm);
     xbd = ['000000000000' bit_half];
     fn.bin = xbd;
     xbd = fi(fn,0,w,f,Fm);

     

     %step 7%%%%%%%%%%%%%%%%%%%%% CALCULATE FINAL GUESS AND COMPARE TO
     %ACTUAL RESULT
     
    yeet = fi(0, 0, 8, 7);
    yeet.bin = '01011010';
    
    yeet2 = fi(0, 0, w, f);
    %yeet2.bin = '000000000000000000000000000001';
    
    if temp~= 1
        y = xa*xbd;
    else
        y = (xa*xbd*yeet) + yeet2;
    end


     y.bin;
     y.data;

     y.data = (1/sqrt(double(x.data)))
     y.hex
     
     
     clear bit_string; 

     
end