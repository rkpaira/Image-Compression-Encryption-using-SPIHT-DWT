function x = func_Mywaverec2(c,s,varargin)

if errargn(mfilename,nargin,[3:4],nargout,[0:1]), error('*'), end

x = func_Myappcoef2(c,s,varargin{:},0);
