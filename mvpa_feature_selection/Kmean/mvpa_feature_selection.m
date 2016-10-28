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
% data: 输入数据
% label: 数据标签
% param: 参数,param(1)最好设定为要选取的特征个数
% output:
% data_f: 经过特征选择变换后的特征矩阵
% apply_param: 输入到mvpa_feature_selection_apply函数中的变换参数,根据该参数进行测试集的特征选择
% idx_weight: 每个特征的权重，根据这个得到一致特征。
%[idxbest, Cbest, sumDbest, Dbest] = kmeans(X, k, varargin);