function a = func_Myappcoef2(c,s,varargin)

if errargn(mfilename,nargin,[3:5],nargout,[0:1]), error('*'), end
rmax = size(s,1);
nmax = rmax-2;
if ischar(varargin{1})
    [Lo_R,Hi_R] = wfilters(varargin{1},'r'); next = 2;
else
    Lo_R = varargin{1}; Hi_R = varargin{2};  next = 3;
end
if nargin>=(2+next) , n = varargin{next}; else, n = nmax; end

if (n<0) | (n>nmax) | (n~=fix(n))
    errargt(mfilename,'invalid level value','msg'); error('*');
end

nl   = s(1,1);
nc   = s(1,2);
a    = zeros(nl,nc);
a(:) = c(1:nl*nc);

rm   = rmax+1;
for p=nmax:-1:n+1
    [h,v,d] = detcoef2('all',c,s,p);
    a = idwt2(a,h,v,d,Lo_R,Hi_R,s(rm-p,:),'mode','per');
end
