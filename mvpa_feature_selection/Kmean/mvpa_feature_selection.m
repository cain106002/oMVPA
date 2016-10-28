function [data_f,apply_param,idx_weight] = mvpa_feature_selection(data,label,param)
kum=param(1);
[A,C]= kmeans(data',kum,'replicates',5);
idx_weight = ones(size(data,2),1);
for i = 1:kum
   data_f(:,i)=mean(data(:,A==i),2);
end
apply_param=A;
end
% input:
% data: ��������
% label: ���ݱ�ǩ
% param: ����,param(1)����趨ΪҪѡȡ����������
% output:
% data_f: ��������ѡ��任�����������
% apply_param: ���뵽mvpa_feature_selection_apply�����еı任����,���ݸò������в��Լ�������ѡ��
% idx_weight: ÿ��������Ȩ�أ���������õ�һ��������
%[idxbest, Cbest, sumDbest, Dbest] = kmeans(X, k, varargin);