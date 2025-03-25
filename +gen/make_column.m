function vec = make_column(vec)

assert(isvector(vec));
if isrow(vec), vec = vec'; end

end