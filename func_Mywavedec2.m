function [c,s] = func_Mywavedec2(x,n,varargin)

if errargn(mfilename,nargin,[3:4],nargout,[0:2]), error('*'), end
if errargt(mfilename,n,'int'), error('*'), end
if nargin==3
    [Lo_D,Hi_D] = wfilters(varargin{1},'d');
else
    Lo_D = varargin{1};   Hi_D = varargin{2};
end


s = [size(x)];
c = [];

for i=1:n
    [x,h,v,d] = dwt2(x,Lo_D,Hi_D,'mode','per'); 
    c = [h(:)' v(:)' d(:)' c];     
    s = [size(x);s];               

end


c = [x(:)' c];
s = [size(x);s];
