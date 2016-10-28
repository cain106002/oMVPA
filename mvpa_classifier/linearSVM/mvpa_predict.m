function [label_predict, score_predict] = mvpa_predict(data,label,model)
%MVPA_PREDICT
[label_predict,~,score_predict] = predict(label,sparse(data),model,'-q');

end

