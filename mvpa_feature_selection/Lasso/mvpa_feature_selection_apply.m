function data_f = mvpa_feature_selection_apply(data,label,apply_param)
% input
% data: ���Լ�����
% label: ���Լ�label
% apply_param: ��mvpa_feature_selection�õ��������任����
% output
% data_f: ����ѡ���Ĳ��Լ�����
data_f = data(:,apply_param);
end