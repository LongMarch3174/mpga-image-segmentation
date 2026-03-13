clear all;
clc; 
NIND = 4;     
NVAR = 1;      
PRECI = 8;     
GGAP = 0.6;    
MP = 5;       
FieldD =[PRECI;1;256;1;0;1;1];   
for i = 1:MP
    Chrom{i} = crtbp(NIND, NVAR*PRECI);   
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
plot(1:gen, YY)
xlabel('进化代数')
ylabel('最优解变化')
title('进化过程')
xlim([1, gen])
%% 保存为EMF图像
output_emf_path = 'evolution_process.emf'; 
print('-dmeta', output_emf_path); 
disp(['进化过程图已保存为EMF格式: ', output_emf_path]);
%% 输出最优解
[Y, I] = max(MaxObjV);    
X = (bs2rv(MaxChrom(I, :), FieldD));   
disp(['最优值为：', num2str(Y)])
disp(['对应的自变量取值：', num2str(X)])
