clear all;
clc;

%% 预处理过程（来自 pre.m）
imga = imread('sample.png');
img0 = rgb2gray(imga);

% 保存原始灰度图像
gray_output_path = 'gray_sample.png';
imwrite(img0, gray_output_path);
disp(['灰度图像已保存至: ', gray_output_path]);

img1 = im2double(img0);
x2 = 2 * size(img1, 1);
y2 = 2 * size(img1, 2);
a = -x2 / 2:(x2 / 2 - 1);
b = -y2 / 2:(y2 / 2 - 1);
[A, B] = meshgrid(a, b);
fd = sqrt(A.^2 + B.^2);
d0 = 300;
n = 3;
LP = 1 ./ (1 + (fd ./ d0).^(2 * n));
J = fftshift(fft2(img1, size(LP, 1), size(LP, 2)));
K = J .* LP;
LI = ifft2(ifftshift(K));
filter_photo = LI(1:size(img1, 1), 1:size(img1, 2));

% 显示并保存滤波后的图像
figure;
imshow(filter_photo);
title('滤波后的图像');

output_path = 'preprocessed_sample.png';
imwrite(uint8(filter_photo * 255), output_path);
disp(['滤波后的图像已保存至: ', output_path]);

%% MPGA 搜索最优阈值
NIND = 4;
NVAR = 1;
PRECI = 8;
GGAP = 0.6;
MP = 5;
FieldD = [PRECI; 1; 256; 1; 0; 1; 1];

for i = 1:MP
    Chrom{i} = crtbp(NIND, NVAR * PRECI);
end

pc = 0.6 + (0.8 - 0.6) * rand(MP, 1);
pm = 0.001 + (0.05 - 0.001) * rand(MP, 1);
gen = 0;
gen0 = 0;
MAXGEN = 10;
maxY = 0;

for i = 1:MP
    ObjV{i} = OTSU(bs2rv(Chrom{i}, FieldD));
end

MaxObjV = zeros(MP, 1);
MaxChrom = zeros(MP, PRECI * NVAR);

while gen0 <= MAXGEN
    gen = gen + 1;
    for i = 1:MP
        FitnV{i} = ranking(-ObjV{i});
        SelCh{i} = select('sus', Chrom{i}, FitnV{i}, GGAP);
        SelCh{i} = recombin('xovsp', SelCh{i}, pc(i));
        SelCh{i} = mut(SelCh{i}, pm(i));
        ObjVSel = OTSU(bs2rv(SelCh{i}, FieldD));
        [Chrom{i}, ObjV{i}] = reins(Chrom{i}, SelCh{i}, 1, 1, ObjV{i}, ObjVSel);
    end

    [Chrom, ObjV] = immigrant(Chrom, ObjV);
    [MaxObjV, MaxChrom] = EliteInduvidual(Chrom, ObjV, MaxObjV, MaxChrom);

    YY(gen) = max(MaxObjV);
    if YY(gen) > maxY
        maxY = YY(gen);
        gen0 = 0;
    else
        gen0 = gen0 + 1;
    end
end

%% 进化过程图
figure;
plot(1:gen, YY);
xlabel('进化代数');
ylabel('最优解变化');
title('进化过程');
xlim([1, gen]);

output_emf_path = 'evolution_process.emf';
print('-dmeta', output_emf_path);
disp(['进化过程图已保存为EMF格式: ', output_emf_path]);

%% 输出最优解
[Y, I] = max(MaxObjV);
X = bs2rv(MaxChrom(I, :), FieldD);
threshold = round(X(1));
disp(['最优值为：', num2str(Y)]);
disp(['对应的自变量取值：', num2str(threshold)]);

%% 分割过程（融合 main.m，并使用最优阈值）
segImg = uint8(filter_photo * 255);
segImg(segImg < threshold) = 0;
segImg(segImg >= threshold) = 255;

figure;
imshow(segImg);
title(['最终分割图像（阈值 = ', num2str(threshold), '）']);

output_seg_emf_path = 'segmented_image.emf';
print('-dmeta', output_seg_emf_path);
disp(['处理后的图像已保存为EMF格式: ', output_seg_emf_path]);

output_seg_png_path = 'segmented_image.png';
imwrite(segImg, output_seg_png_path);
disp(['处理后的图像已保存为PNG格式: ', output_seg_png_path]);
