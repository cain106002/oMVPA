function mvpa_model = mvpa_classify(data,label,param)
%MVPA_CLASSIFY
mvpa_model = svmtrain(label(:,1),data,['-q',' -c ',num2str(param(1)),' -g ',num2str(param(2))]);
end