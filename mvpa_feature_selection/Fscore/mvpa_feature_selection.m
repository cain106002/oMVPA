function [data_f,apply_param,idx_weight] = mvpa_feature_selection(data,label,param)
fnum = abs(param(1));
if(fnum<=0)
    fnum = 1;
elseif(fnum>size(data,2))
    fnum = size(data,2);
end
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