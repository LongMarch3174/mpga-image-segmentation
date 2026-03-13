I = imread('sample.png');

img = rgb2gray(I);
x = size(img,1);
y = size(img,2);
for i = 1:x
    for j = 1:y
        if img(i,j) < 102 
            img(i,j) = 0;
        else
            img(i,j) = 255;
        end
    end
end

%% 显示处理后的图像
figure
imshow(img);

%% 保存为EMF图像
output_emf_path = 'segmented_image.emf'; % 保存路径
print('-dmeta', output_emf_path); % 使用 -dmeta 参数保存为EMF格式
disp(['处理后的图像已保存为EMF格式: ', output_emf_path]);
