function mvpa_model = mvpa_classify(data,label,param)
%MVPA_CLASSIFY

if(param<=0)
    param = 2^-10;
end
mvpa_model = train(label(:,1),sparse(data),['-c ',num2str(param)]);

end