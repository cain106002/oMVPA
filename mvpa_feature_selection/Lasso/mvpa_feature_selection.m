function [data_f,apply_param,idx_weight] = mvpa_feature_selection(data,label,param)

A=data;       % the data matrix
rho=param(2);            % the regularization parameter
                    % it is a ratio between (0,1), if .rFlag=1
%----------------------- Set optional items ------------------------
opts=[];
% Starting point
opts.init=2;        % starting from a zero point
% termination criterion
opts.tFlag=5;       % run .maxIter iterations
opts.maxIter=100;   % maximum number of iterations
% normalization
opts.nFlag=0;       % without normalization
% regularization
opts.rFlag=1;       % the input parameter 'rho' is a ratio in (0, 1)
%opts.rsL2=0.01;     % the squared two norm term
%----------------------- Run the code LeastR -----------------------
opts.mFlag=0;       % treating it as compositive function 
opts.lFlag=0;       % Nemirovski's line search
label_new = label-mean(label);
[x1, funVal1, ValueL1]= LeastR(A, label_new, rho, opts);
idx_weight=abs(x1);
[B,I]=sort(abs(x1),'descend');
data_f=data(:,I(1:param(1)));
apply_param=I(1:param(1));
end