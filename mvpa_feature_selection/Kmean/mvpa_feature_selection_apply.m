function data_f = mvpa_feature_selection_apply(data,label,apply_param)
% input
% data: 测试集数据
% label: 测试集label
% apply_param: 又mvpa_feature_selection得到的特征变换参数
% output
% data_f: 特征选择后的测试集数据
A = apply_param;
for i = 1:max(A(:))
   data_f(:,i)=mean(data(:,A==i),2);
end
end