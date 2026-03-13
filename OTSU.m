function obj=OTSU(X)
col=size(X,1);
 
I= imread('preprocessed_sample.png');
%K = rgb2gray(I);
K = I;
x = size(K,1);
y = size(K,2);
h=imhist(K); 
for k = 0:255
   P(k+1,1) = h(k+1,1)/(x*y);
end
 
for i=1:col
    n =X(i,1);
    s = 0.0;
    w0 = 0.0;
    for j = 0:n
        s =s + j * P(j+1,1);
        w0 = w0+P(j+1,1);
    end
    s0 = s/w0;
    w1 = 1-w0;
    s3 = 0.0;
    for l = 0:255
        s3 = s3 + l*P(l+1,1);
    end
    s1 = (s3-s)/w1;
    obj(i,1) = w0*w1*(s1-s0)^2;
end
