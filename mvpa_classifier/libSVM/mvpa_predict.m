function [label_predict, score_predict] = mvpa_predict(data,label,model)
%MVPA_PREDICT
[label_predict,~,score_predict] = svmpredict(label,data,model,'-q');

end