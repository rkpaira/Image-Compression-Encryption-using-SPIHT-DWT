function m = decoding(in)


m = zeros(in(1,1));
n_max = in(1,2);
level = in(1,3);
ctr = 4;
 
%-----------   Initialize LIP, LSP, LIS   ----------------
temp = [];
bandsize = 2.^(log2(in(1,1)) - level + 1);
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

%-----------   coding   ----------------
n = n_max;
while (ctr <= size(in,2))
    
    %Sorting Pass
    LIPtemp = LIP; temp = 0;
    for i = 1:size(LIPtemp,1)
        temp = temp+1;
        if ctr > size(in,2)
            return
        end
        if in(1,ctr) == 1
            ctr = ctr + 1;
            if in(1,ctr) > 0
                m(LIPtemp(i,1),LIPtemp(i,2)) = 2^n + 2^(n-1);  
            else
                m(LIPtemp(i,1),LIPtemp(i,2)) = -2^n  - 2^(n-1); 
            end
            LSP = [LSP; LIPtemp(i,:)];
            LIP(temp,:) = []; temp = temp - 1;
        end
        ctr = ctr + 1;
    end
    
    LIStemp = LIS; temp = 0; i = 1;
    while ( i <= size(LIStemp,1))
        temp = temp + 1;
        if ctr > size(in,2)
            return
        end
        if LIStemp(i,3) == 0
            if in(1,ctr) == 1 
                ctr = ctr + 1;
                x = LIStemp(i,1); y = LIStemp(i,2);
                
                if ctr > size(in,2)
                    return
                end
                if in(1,ctr) == 1
                    LSP = [LSP; 2*x-1 2*y-1];
                    ctr = ctr + 1;
                    if in(1,ctr) == 1
                        m(2*x-1,2*y-1) = 2^n + 2^(n-1); 
                    else
                        m(2*x-1,2*y-1) = -2^n  - 2^(n-1); 
                    end
                    ctr = ctr + 1;
                else
                    LIP = [LIP; 2*x-1 2*y-1];
                    ctr = ctr + 1;
                end
                
                if ctr > size(in,2)
                    return
                end
                if in(1,ctr) == 1
                    ctr = ctr + 1;
                    LSP = [LSP; 2*x-1 2*y];
                    if in(1,ctr) == 1;
                        m(2*x-1,2*y) = 2^n + 2^(n-1); 
                    else
                        m(2*x-1,2*y) = -2^n  - 2^(n-1); 
                    end
                    ctr = ctr + 1;
                else
                    LIP = [LIP; 2*x-1 2*y];
                    ctr = ctr + 1;
                end
                
                if ctr > size(in,2)
                    return
                end
                if in(1,ctr) == 1
                    ctr = ctr + 1;
                    LSP = [LSP; 2*x 2*y-1];
                    if in(1,ctr) == 1
                        m(2*x,2*y-1) = 2^n + 2^(n-1); 
                    else
                        m(2*x,2*y-1) = -2^n  - 2^(n-1);
                    end
                    ctr = ctr + 1;
                else
                    LIP = [LIP; 2*x 2*y-1];
                    ctr = ctr + 1;
                end
                
                if ctr > size(in,2)
                    return
                end
                if in(1,ctr) == 1
                    ctr = ctr + 1;
                    LSP = [LSP; 2*x 2*y];
                    if in(1,ctr) == 1
                        m(2*x,2*y) = 2^n + 2^(n-1); 
                    else
                        m(2*x,2*y) = -2^n  - 2^(n-1); 
                    end
                    ctr = ctr + 1;
                else
                    LIP = [LIP; 2*x 2*y];
                    ctr = ctr + 1;
                end
                
                if ((2*(2*x)-1) < size(m) & (2*(2*y)-1) < size(m))
                    LIS = [LIS; LIStemp(i,1) LIStemp(i,2) 1];
                    LIStemp = [LIStemp; LIStemp(i,1) LIStemp(i,2) 1];
                end
                LIS(temp,:) = []; temp = temp-1;
                
            else
                ctr = ctr + 1;
            end
        else
            if in(1,ctr) == 1
                x = LIStemp(i,1); y = LIStemp(i,2);
                LIS = [LIS; 2*x-1 2*y-1 0; 2*x-1 2*y 0; 2*x 2*y-1 0; 2*x 2*y 0];
                LIStemp = [LIStemp; 2*x-1 2*y-1 0; 2*x-1 2*y 0; 2*x 2*y-1 0; 2*x 2*y 0];
                LIS(temp,:) = []; temp = temp - 1;
            end
            ctr = ctr + 1;
        end
        i = i+1;
    end
    
    % Refinement Pass
    temp = 1;
    value = m(LSP(temp,1), LSP(temp,2));
    while (abs(value) >= 2^(n+1) & (temp <= size(LSP,1)))
        if ctr > size(in,2)
            return
        end

        value = value + ((-1)^(in(1,ctr) + 1)) * (2^(n-1))*sign(m(LSP(temp,1),LSP(temp,2))); 
        m(LSP(temp,1),LSP(temp,2)) = value;
        ctr = ctr + 1;
        temp = temp + 1;    
        if temp <= size(LSP,1)
            value = m(LSP(temp,1),LSP(temp,2));
        end
    end
    
    n = n-1;
end