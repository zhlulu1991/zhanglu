% 函数名称：主成分分析法(PCA-特征值特征向量法)                                (2015-12-28 23:06)
% 作    者：胡志强 北京工业大学 zacharyhu33@163.com (Matlab R2014a)
% 描    述：X → X_norm → R → R*P = λ*P → λ1,λ2,... → δ,η → t
% 参考文献：无
% 调用函数：无
% 调试程序：
%        close all; clear all; clc
%        C = [1 2 3 4 5 6 7];
%        [Data,V,N] = ReadXlsData_HZQ(C);
%        Z = PCA_HZQ(Data);
% 函数内容：
function t = PCA_HZQ(X)
% 输出： t — 降维后矩阵     输入：X — 输入矩阵 
%% 主程序
X=[0.831 5.987 4.5 22.61 5.68 1.98 
0.843 5.980 4.21 22.62 5.7 1.91
0.866 5.966 4.13 22.54 7.35 1.96 
0.865 5.965 4.29 22.64 5.76 1.96 
0.823 5.985 4.15 22.13 5.71 1.93 
0.887 5.975 4.23 22.81 5.92 1.99 
0.856 5.976 4.1 22.71 5.82 2.09 
0.833 5.977 4.11 22.69 5.96 2.03 
0.862 5.976 4.09 22.86 5.9 1.98 
0.863 5.974 4.04 22.92 5.85 1.98];
disp('输入矩阵：'); disp(X);
%% 标准化（X_norm）
% X_norm = zscore(X);
[a,b] = size(X);
for j = 1:b
    mju(j) = mean(X(:,j));
    sigma(j) = std(X(:,j));
end
for i = 1:a
    for j = 1:b
        X_norm(i,j) = (X(i,j)-mju(j))/sigma(j); 
    end
end
disp('标准化矩阵：'); disp(X_norm);                                       
%% 协方差矩阵（R）
% cov(X_norm) = corrcoef(X) = corrcoef(X_norm);
R = cov(X_norm);                                                            % 原始矩阵的相关系数矩阵 = 标准化后矩阵的协方差矩阵，因为标准差为1
disp('协方差矩阵：'); disp(R);                                               % 对于标准化后的矩阵X，协方差矩阵 = 相关系数矩阵，因为均值为0
%% 特征向量（P）,特征值(λ)
[P,lambda] = eig(R);                                                        % λ：默认升序
disp('特征向量：'); disp(P);
disp('特征值：'); disp(lambda);
%% 特征根排序（λ1,λ2,...）
diag_lambda = diag(lambda);
[lambda_sort,i] = sort(diag_lambda,1,'descend');                            % [y(列降序),i(索引)]
P_new = P(:,i);                                                             % 特征向量与特征值相对应
disp('特征值排序（从大到小）：'); disp(lambda_sort');
disp('特征值排序后对应原序号：'); disp(i');
disp('特征向量（对应特征值）：'); disp(P_new);                                                           
%% 方差贡献率（δ）
sum_rate = 0; i_rate = [];
rate = lambda_sort./sum(lambda_sort);
disp('方差贡献率：'); disp(rate');
%% 累计贡献率（η）
for k = 1:length(rate)
    sum_rate(k) = sum(rate(1:k));
    i_rate(k) = i(k);
    if sum_rate(k)>0.85 
        break; 
    end  
end
disp('累积贡献率：'); disp(sum_rate);
disp('累积贡献率编号：'); disp(i_rate);
disp('主成分个数：'); disp(length(i_rate));
%% 主元（t）
t = X_norm*P_new;              
disp('主元：'); disp(t);
%% 画图
% 箱线图
figure
categories = ['1';'2';'3';'4';'5';'6'];
boxplot(X_norm,'orientation','horizontal','labels',categories); grid on; 
print -djpeg 1;
% 贡献率
figure
rate = 100*lambda_sort./sum(lambda_sort);
pareto(rate);
print -djpeg 1;
xlabel('Principal Component'); ylabel('Variance Explained (%)');
print -djpeg 2;
% 主成分载荷
figure
biplot(P_new(:,1:2), 'scores',t(:,1:2),... 
'varlabels',categories);
axis([-1 1 -1 1]);
print -djpeg 3;
% [coef,score,latent,t2] = princomp(X_norm);
% coef：特征向量 Pnew
% score：主元 t
% latent：特征值 lambda_sort
% t2：多元统计距离