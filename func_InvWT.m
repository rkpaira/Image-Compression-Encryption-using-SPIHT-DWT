function im_rec = func_InvWT(I_W, S, Lo_R, Hi_R, level);


L = length(S);

m = I_W;

C1 = zeros(1,S(1,3)+3*sum(S(2:L-1,3)));


C1(1:S(1,3)) = reshape( m( 1:S(1,1) , 1:S(1,2) ), 1 , S(1,3) );

for k = 2:L-1
    rows = [sum(S(1:k-1,1))+1:sum(S(1:k,1))];
    columns = [sum(S(1:k-1,2))+1:sum(S(1:k,2))];
   
    c_start = S(1,3) + 3*sum(S(2:k-1,3)) + 1;
    c_stop = S(1,3) + 3*sum(S(2:k-1,3)) + S(k,3);
    C1(c_start:c_stop) = reshape( m( 1:S(k,1) , columns ) , 1, c_stop-c_start+1);
    
    c_start = S(1,3) + 3*sum(S(2:k-1,3)) + S(k,3) + 1;
    c_stop = S(1,3) + 3*sum(S(2:k-1,3)) + 2*S(k,3);
    C1(c_start:c_stop) = reshape( m( rows , 1:S(k,2) ) , 1 , c_stop-c_start+1 );
    
    c_start = S(1,3) + 3*sum(S(2:k-1,3)) + 2*S(k,3) + 1;
    c_stop = S(1,3) + 3*sum(S(2:k,3));
    C1(c_start:c_stop) = reshape( m( rows , columns ) , 1 , c_stop-c_start+1);
end

if (( L - 2) > level)   
    temp = zeros(1, length(C1) - (S(1,3)+3*sum(S(2:(level+1),3))));
    C1(S((level+2),3)+1 : length(C1)) = temp;
end

S(:,3) = [];

im_rec = func_Mywaverec2(C1,S, Lo_R, Hi_R); 

