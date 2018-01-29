function out = encoding(m, max_bits, block_size, level)

figure;
imshow(m);
bitctr = 0;
out = 2*ones(1,max_bits);
n_max = floor(log2(abs(max(max(m)'))));
Bits_Header = 0;
Bits_LSP = 0;
Bits_LIP = 0;
Bits_LIS = 0;


out(1,[1 2 3]) = [size(m,1) n_max level]; bitctr = bitctr + 24;
index = 4;
Bits_Header = Bits_Header + 24;

%-----------   Initialize LIP, LSP, LIS   ----------------
temp = [];
bandsize = 2.^(log2(size(m, 1)) - level + 1);
temp1 = 1 : bandsize;
for i = 1 : bandsize
    temp = [temp; temp1];
end
LIP(:, 1) = temp(:);
temp = temp';
LIP(:, 2) = temp(:);
LIS(:, 1) = LIP(:, 1);
LIS(:, 2) = LIP(:, 2);
LIS(:, 3) = zeros(length(LIP(:, 1)), 1);
pstart = 1;
pend = bandsize / 2;
for i = 1 : bandsize / 2
    LIS(pstart : pend, :) = [];
    pdel = pend - pstart + 1;
    pstart = pstart + bandsize - pdel;
    pend = pend + bandsize - pdel;
end
LSP = [];

n = n_max;

%coding
while(bitctr < max_bits)
        
    % Sorting Pass
    LIPtemp = LIP; temp = 0;
    for i = 1:size(LIPtemp,1)
        temp = temp+1;
        if (bitctr + 1) >= max_bits
            if (bitctr < max_bits)
                out(length(out))=[];
            end
            return
        end
        if abs(m(LIPtemp(i,1),LIPtemp(i,2))) >= 2^n % 1: positive; 0: negative
            out(index) = 1; bitctr = bitctr + 1;
            index = index +1; Bits_LIP = Bits_LIP + 1;
            sgn = m(LIPtemp(i,1),LIPtemp(i,2))>=0;
            out(index) = sgn; bitctr = bitctr + 1;
            index = index +1; Bits_LIP = Bits_LIP + 1;
            LSP = [LSP; LIPtemp(i,:)];
            LIP(temp,:) = []; temp = temp - 1;
        else
            out(index) = 0; bitctr = bitctr + 1;
            index = index +1;
            Bits_LIP = Bits_LIP + 1;
        end
    end
    
    LIStemp = LIS; temp = 0; i = 1;
    while ( i <= size(LIStemp,1))
        temp = temp + 1;
        if LIStemp(i,3) == 0
            if bitctr >= max_bits
                return
            end
            max_d = func_MyDescendant(LIStemp(i,1),LIStemp(i,2),LIStemp(i,3),m);
            if max_d >= 2^n
                out(index) = 1; bitctr = bitctr + 1;
                index = index +1; Bits_LIS = Bits_LIS + 1;
                x = LIStemp(i,1); y = LIStemp(i,2);
                
                if (bitctr + 1) >= max_bits
                    if (bitctr < max_bits)
                        out(length(out))=[];
                    end
                    return
                end
                if abs(m(2*x-1,2*y-1)) >= 2^n
                    LSP = [LSP; 2*x-1 2*y-1];
                    out(index) = 1; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                    sgn = m(2*x-1,2*y-1)>=0;
                    out(index) = sgn; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                else
                    out(index) = 0; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                    LIP = [LIP; 2*x-1 2*y-1];
                end
                
                if (bitctr + 1) >= max_bits
                    if (bitctr < max_bits)
                        out(length(out))=[];
                    end
                    return
                end
                if abs(m(2*x-1,2*y)) >= 2^n
                    LSP = [LSP; 2*x-1 2*y];
                    out(index) = 1; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                    sgn = m(2*x-1,2*y)>=0;
                    out(index) = sgn; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                else
                    out(index) = 0; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                    LIP = [LIP; 2*x-1 2*y];
                end
                
                if (bitctr + 1) >= max_bits
                    if (bitctr < max_bits)
                        out(length(out))=[];
                    end
                    return
                end
                if abs(m(2*x,2*y-1)) >= 2^n
                    LSP = [LSP; 2*x 2*y-1];
                    out(index) = 1; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                    sgn = m(2*x,2*y-1)>=0;
                    out(index) = sgn; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                else
                    out(index) = 0; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                    LIP = [LIP; 2*x 2*y-1];
                end
                
                if (bitctr + 1) >= max_bits
                    if (bitctr < max_bits)
                        out(length(out))=[];
                    end
                    return
                end
                if abs(m(2*x,2*y)) >= 2^n
                    LSP = [LSP; 2*x 2*y];
                    out(index) = 1; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                    sgn = m(2*x,2*y)>=0;
                    out(index) = sgn; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                else
                    out(index) = 0; bitctr = bitctr + 1;
                    index = index +1; Bits_LIS = Bits_LIS + 1;
                    LIP = [LIP; 2*x 2*y];
                end
                
                if ((2*(2*x)-1) < size(m) & (2*(2*y)-1) < size(m))
                    LIS = [LIS; LIStemp(i,1) LIStemp(i,2) 1];
                    LIStemp = [LIStemp; LIStemp(i,1) LIStemp(i,2) 1];
                end
                LIS(temp,:) = []; temp = temp-1;
                
            else
                out(index) = 0; bitctr = bitctr + 1;
                index = index +1; Bits_LIS = Bits_LIS + 1;
            end
        else
            if bitctr >= max_bits
                return
            end
            max_d = func_MyDescendant(LIStemp(i,1),LIStemp(i,2),LIStemp(i,3),m);
            if max_d >= 2^n
                out(index) = 1; bitctr = bitctr + 1;
                index = index +1;
                x = LIStemp(i,1); y = LIStemp(i,2);
                LIS = [LIS; 2*x-1 2*y-1 0; 2*x-1 2*y 0; 2*x 2*y-1 0; 2*x 2*y 0];
                LIStemp = [LIStemp; 2*x-1 2*y-1 0; 2*x-1 2*y 0; 2*x 2*y-1 0; 2*x 2*y 0];
                LIS(temp,:) = []; temp = temp - 1;
            else
                out(index) = 0; bitctr = bitctr + 1;
                index = index +1; Bits_LIS = Bits_LIS + 1;
            end
        end
        i = i+1;
    end
    
    % Refinement Pass
    temp = 1;
    value = floor(abs(2^(n_max-n+1)*m(LSP(temp,1),LSP(temp,2))));
    while (value >= 2^(n_max+2) & (temp <= size(LSP,1)))
        if bitctr >= max_bits
            return
        end
        s = bitget(value,n_max+2);
        out(index) = s; bitctr = bitctr + 1;
        index = index +1; Bits_LSP = Bits_LSP + 1;
        temp = temp + 1;
        if temp <= size(LSP,1)
            value = floor(abs(2^(n_max-n+1)*m(LSP(temp,1),LSP(temp,2))));
        end
    end
    
    n = n - 1;
end
