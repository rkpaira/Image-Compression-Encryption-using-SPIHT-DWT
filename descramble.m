function out =descramble(I,a,input)
row = size(input, 1) / 64;
col = size(input, 2) / 64;
b=1:length(a);
com=[a' b'];
com=sortrows(com,1);
I = mat2cell(I, ones(1, row) * 64, ones(1, col) * 64, size(input, 3));
I = cell2mat(reshape(I(com(:,2)), row, col));
figure;
imshow(I);