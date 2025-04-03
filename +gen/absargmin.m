function i = absargmin(varargin)
if nargin > 1
    varargin = {varargin{1},[],varargin{2:end}};
end
[~, i] = min(abs(varargin{1}),varargin{2:end});

end