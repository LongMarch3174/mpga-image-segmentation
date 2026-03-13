imga=imread('sample.png'); 
img0=rgb2gray(imga);
%% 保存原始灰度图像
gray_output_path = 'gray_sample.png'; 
imwrite(img0, gray_output_path);
disp(['灰度图像已保存至: ', gray_output_path]);
%%
img1=im2double(img0);
x=2*size(img1,1);
y=2*size(img1,2);
a=-x/2:(x/2-1);
b=-y/2:(y/2-1);
[A,B]=meshgrid(a,b);
fd=sqrt(A.^2+B.^2);
d0=300;
n=3;
LP=1./(1+(fd./d0).^(2*n));
J=fftshift(fft2(img1,size(LP,1),size(LP,2)));
K=J.*LP;
LI=ifft2(ifftshift(K));
filter_photo=LI(1:size(img1,1),1:size(img1,2));

%% 显示滤波后的图像
figure;
imshow(filter_photo);
title('滤波后的图像');

%% 保存滤波后的图像
output_path = 'preprocessed_sample.png'; % 保存路径
imwrite(uint8(filter_photo * 255), output_path);
disp(['滤波后的图像已保存至: ', output_path]);
