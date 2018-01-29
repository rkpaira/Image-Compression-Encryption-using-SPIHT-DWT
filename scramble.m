function [out,a] =scramble(I)

row = size(I, 1) / 64;
col = size(I, 2) / 64;
out = mat2cell(I, ones(1, row) * 64, ones(1, col) * 64, size(I, 3));
a=randperm(row * col);
out = cell2mat(reshape(out(a), row, col));
figure;
imshow(out);