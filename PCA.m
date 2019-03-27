% �������ƣ����ɷַ�����(PCA-����ֵ����������)                                (2015-12-28 23:06)
% ��    �ߣ���־ǿ ������ҵ��ѧ zacharyhu33@163.com (Matlab R2014a)
% ��    ����X �� X_norm �� R �� R*P = ��*P �� ��1,��2,... �� ��,�� �� t
% �ο����ף���
% ���ú�������
% ���Գ���
%        close all; clear all; clc
%        C = [1 2 3 4 5 6 7];
%        [Data,V,N] = ReadXlsData_HZQ(C);
%        Z = PCA_HZQ(Data);
% �������ݣ�
function t = PCA_HZQ(X)
% ����� t �� ��ά�����     ���룺X �� ������� 
%% ������
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
disp('�������'); disp(X);
%% ��׼����X_norm��
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
disp('��׼������'); disp(X_norm);                                       
%% Э�������R��
% cov(X_norm) = corrcoef(X) = corrcoef(X_norm);
R = cov(X_norm);                                                            % ԭʼ��������ϵ������ = ��׼��������Э���������Ϊ��׼��Ϊ1
disp('Э�������'); disp(R);                                               % ���ڱ�׼����ľ���X��Э������� = ���ϵ��������Ϊ��ֵΪ0
%% ����������P��,����ֵ(��)
[P,lambda] = eig(R);                                                        % �ˣ�Ĭ������
disp('����������'); disp(P);
disp('����ֵ��'); disp(lambda);
%% ���������򣨦�1,��2,...��
diag_lambda = diag(lambda);
[lambda_sort,i] = sort(diag_lambda,1,'descend');                            % [y(�н���),i(����)]
P_new = P(:,i);                                                             % ��������������ֵ���Ӧ
disp('����ֵ���򣨴Ӵ�С����'); disp(lambda_sort');
disp('����ֵ������Ӧԭ��ţ�'); disp(i');
disp('������������Ӧ����ֵ����'); disp(P_new);                                                           
%% ������ʣ��ģ�
sum_rate = 0; i_rate = [];
rate = lambda_sort./sum(lambda_sort);
disp('������ʣ�'); disp(rate');
%% �ۼƹ����ʣ��ǣ�
for k = 1:length(rate)
    sum_rate(k) = sum(rate(1:k));
    i_rate(k) = i(k);
    if sum_rate(k)>0.85 
        break; 
    end  
end
disp('�ۻ������ʣ�'); disp(sum_rate);
disp('�ۻ������ʱ�ţ�'); disp(i_rate);
disp('���ɷָ�����'); disp(length(i_rate));
%% ��Ԫ��t��
t = X_norm*P_new;              
disp('��Ԫ��'); disp(t);
%% ��ͼ
% ����ͼ
figure
categories = ['1';'2';'3';'4';'5';'6'];
boxplot(X_norm,'orientation','horizontal','labels',categories); grid on; 
print -djpeg 1;
% ������
figure
rate = 100*lambda_sort./sum(lambda_sort);
pareto(rate);
print -djpeg 1;
xlabel('Principal Component'); ylabel('Variance Explained (%)');
print -djpeg 2;
% ���ɷ��غ�
figure
biplot(P_new(:,1:2), 'scores',t(:,1:2),... 
'varlabels',categories);
axis([-1 1 -1 1]);
print -djpeg 3;
% [coef,score,latent,t2] = princomp(X_norm);
% coef���������� Pnew
% score����Ԫ t
% latent������ֵ lambda_sort
% t2����Ԫͳ�ƾ���