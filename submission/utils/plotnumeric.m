function [] = plotnumeric(X, varargin)
% Plots a matrix with numeric values.

clim = [min(X(:)) max(X(:))];
fmt = '%.3f';

imagesc(X, clim);
colormap(autumn);

for i = 1:size(X,1)
  for j = 1:size(X,2)
      text(j,i, sprintf(fmt, X(i,j)), ...
           'HorizontalAlignment', 'center', 'color', 'black');    
  end
end
