function [I_W , S] = func_WT(I, level, Lo_D, Hi_D);


[C,S] = func_Mywavedec2(I,level,Lo_D,Hi_D); 

S(:,3) = S(:,1).*S(:,2);        

L = length(S);

I_W = zeros(S(L,1),S(L,2));


I_W( 1:S(1,1) , 1:S(1,2) ) = reshape(C(1:S(1,3)),S(1,1:2));

for k = 2 : L-1
    rows = [sum(S(1:k-1,1))+1:sum(S(1:k,1))];
    columns = [sum(S(1:k-1,2))+1:sum(S(1:k,2))];
    
    c_start = S(1,3) + 3*sum(S(2:k-1,3)) + 1;
    c_stop = S(1,3) + 3*sum(S(2:k-1,3)) + S(k,3);
    I_W( 1:S(k,1) , columns ) = reshape( C(c_start:c_stop) , S(k,1:2) );

    
    c_start = S(1,3) + 3*sum(S(2:k-1,3)) + S(k,3) + 1;
    c_stop = S(1,3) + 3*sum(S(2:k-1,3)) + 2*S(k,3);
    I_W( rows , 1:S(k,2) ) = reshape( C(c_start:c_stop) , S(k,1:2) );

   
    c_start = S(1,3) + 3*sum(S(2:k-1,3)) + 2*S(k,3) + 1;
    c_stop = S(1,3) + 3*sum(S(2:k,3));
    I_W( rows , columns ) = reshape( C(c_start:c_stop) , S(k,1:2) );

end

