function [data_f,apply_param,idx_weight] = mvpa_feature_selection(data,label,param)
% input:
% data: ��������
% label: ���ݱ�ǩ
% param: ����,param(1)����趨ΪҪѡȡ����������
% output:
% data_f: ��������ѡ��任�����������
% apply_param: ���뵽mvpa_feature_selection_apply�����еı任����,���ݸò������в��Լ�������ѡ��
% idx_weight: ÿ��������Ȩ�أ���������õ�һ��������

fnum = param(1);
label_fs = label(:,1);
label_unique = unique(label_fs);
for i = 1:length(label_unique)
    label_fs(label == label_unique(i)) = i;
end
out = fsFisher(data,label_fs);
idx_weight = zeros(size(data,2),1);
idx_weight(out.fList(1:fnum)) = out.W(out.fList(1:fnum));
apply_param = out.fList(1:fnum);
data_f = data(:,apply_param);
end