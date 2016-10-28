function [sele_index,newlabel]=mvpa_subject_selection(label,scores)
%MVPA_SUBJECT_SELECTION create a balanced dataset
% create a balanced dataset 
% eg: the input data is 20 vs 30, the destination of this function is to
% select a most matched dataset of 20 vs 20
% 
% if extra is empty, the first 20 subject in group2 will be selected
% extra: the first row indicate the type of measures of each subjects
% (1:continuous or 2:distinct)
%
% created by Yangyang Yu 2016.09.12
% modified by Heng Chen 2016.09.19
sele_index = ones(length(label),1);
num=unique(label);
for i=1:length(num)
    % use sum instead of length
    ln(i)=sum(label==num(i));
end
min_number=min(ln);
if(sum(ln ~= min_number) == 0)
    newlabel = label;
    return;
end
del=[];
if(isempty(scores))
    for i=1:length(num)
        ind=find(label==num(i));
        if length(ind)>min_number
            temp=ind(min_number+1:end,:);
            del=[del;temp];
        end
    end
else
    desp = scores(1,:);
    scores = scores(2:end,:);
    ind_max = find(max(ln));
    for i = 1:length(num)
        ind{i} = find(label == num(i));
    end
    ln_tmp = ln;
    while(sum(ln_tmp ~= min_number) ~= 0)
        p_max = 0;
        ind_max = ind{find(ln_tmp == max(ln_tmp),1,'first')};
        ln_tmp(find(ln_tmp == max(ln_tmp),1,'first')) = ...
            ln_tmp(find(ln_tmp == max(ln_tmp),1,'first'))-1;
        for i = 1:length(ind_max)
            if(sum(ind_max(i) == del) == 1)
                continue
            end
            del_tmp = [del,ind_max(i)];
            scores_tmp = scores;
            scores_tmp(del_tmp,:) = [];
            label_tmp = label;
            label_tmp(del_tmp,:) = [];
            p_current = p_cal(scores_tmp,desp,label_tmp);
            if(p_current>p_max)
                del_max = ind_max(i);
                p_max = p_current;
            end
        end
        del = [del,del_max];
    end 
end
label(del,:)=[];
sele_index(del,:) = 0;
newlabel=label;
end

function p = p_cal(scores_cal,desp_cal,label_cal)
p = 1;
for i_p_cal = 1:size(scores_cal,2)
    score_tmp = scores_cal(:,i_p_cal);
    if(desp_cal(i_p_cal) == 1) % continous
        p_tmp = anova1(score_tmp,label_cal,'off');
    elseif(desp_cal(i_p_cal) == 2)
        [~,~,p_tmp] = crosstab(label_cal,score_tmp);
    else
        p_tmp = 1;
    end
    p = p*p_tmp;
end
end