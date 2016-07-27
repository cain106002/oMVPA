function [train_idx,test_idx] = mvpa_cross_validation(label,k)

whole_idx = 1:length(label);
whole_idx = whole_idx(randperm(length(label)));
sec_num = floor(length(label)/k);
for i = 1:k
    train_idx_tmp = 1:length(label);
    if(i == k)
        test_idx_tmp = ((i-1)*sec_num+1):length(label);
        train_idx_tmp(test_idx_tmp) = [];
    else
        test_idx_tmp = ((i-1)*sec_num+1):(i*sec_num);
        train_idx_tmp(test_idx_tmp) = [];
    end
    train_idx{i} = whole_idx(train_idx_tmp);
    test_idx{i} = whole_idx(test_idx_tmp);
end
        
    
    