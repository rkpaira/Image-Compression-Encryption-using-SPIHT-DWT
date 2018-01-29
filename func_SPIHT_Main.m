function func_SPIHT_Main


 infilename = 'lena512.bmp';

 outfilename = 'lena512_reconstruct2.bmp';

I = imread(infilename);
figure;
imshow(I);
row = size(I, 1) / 16;
col = size(I, 2) / 16;
I_scramble = mat2cell(I, ones(1, row) * 16, ones(1, col) * 16, size(I, 3));
a=randperm(row * col);
I_scramble = cell2mat(reshape(I_scramble(a), row, col));
figure;
imshow(I_scramble);
Orig_I = double(I_scramble);

rate = 1;

OrigSize = size(Orig_I, 1);
max_bits = floor(rate * OrigSize^2);
OutSize = OrigSize;
image_spiht = zeros(size(Orig_I));
[nRow, nColumn] = size(Orig_I);
fprintf('input image\n');
fprintf('done !\n');

fprintf('wavelet decomposition\n');
n = size(Orig_I,1);
n_log = log2(n); 
level = n_log;


type = 'bior4.4';
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(type);

[I_W, S] = func_WT(Orig_I, level, Lo_D, Hi_D);

fprintf('done !\n');

fprintf('encoding\n');
img_enc = encoding(I_W, max_bits, nRow*nColumn, level); 
fprintf('done!\n');

fprintf('decoding\n');
img_dec = decoding(img_enc);

fprintf('done!\n');
fprintf('wavelet reconstruction\n');
img_spiht = func_InvWT(img_dec, S, Lo_R, Hi_R, level);
fprintf('done!\n');
fprintf('-----------   PSNR analysis   ----------------\n');
Q = 255;
MSE = sum(sum((img_spiht-Orig_I).^2))/nRow / nColumn;
fprintf('The psnr performance is %.2f dB\n', 10*log10(Q*Q/MSE));
b=1:length(a);
com=[a' b'];
com=sortrows(com,1);
img_spiht = mat2cell(img_spiht, ones(1, row) * 16, ones(1, col) * 16, size(I, 3));
img_spiht = cell2mat(reshape(img_spiht(com(:,2)), row, col));
%figure;
%imshow(img_spiht);

imwrite(img_spiht, gray(256), outfilename, 'bmp');
figure;
imshow(outfilename);



