function [mp_data,mp_label] = mvpa_read_data_nii(mp_input_param)
%% lizhiqiang 2016/6/2
%% ��ȡnii���ݣ����뵽app��
%% mp_input_param������Ľṹ�壬�����������ͣ�����λ��,maskλ�ã�labelλ��

%% ��ȡ����
path=mp_input_param.data_path;
maskpath=mp_input_param.mask_path;
maskdata=rest_ReadNiftiImage(maskpath);
maskdata=reshape(maskdata,size(maskdata,1)*size(maskdata,2)*size(maskdata,3),size(maskdata,4));
temp=dir(path);
temp=temp(3:end);
mp_data=zeros(length(temp),size(maskdata,1)*size(maskdata,2)*size(maskdata,3));
 for i=1:length(temp)
    p=[path,filesep,temp(i).name];
    d=dir([p,filesep,'*nii']);
    if(isempty(d)) %·�������ļ�
    [data,~] =rest_ReadNiftiImage(p);%��ȡ����
    else % ·�������ļ���
    dpath=[path,filesep,temp(i).name,filesep,d.name];%��������·��
    [data,~] =rest_ReadNiftiImage(dpath);%��ȡ����
    end
    data=reshape(data,size(data,1)*size(data,2)*size(data,3),size(data,4));
    mp_data(i,:)=data.*maskdata;
 end
%% ��ȡ��ǩ:��ǩ�ļ���ֻ���һ��mat�ļ�������
labelpath=mp_input_param.label_path;
labeltemp=dir(labelpath);
labeltemp=labeltemp(3);
labelp=[labelpath,filesep,labeltemp.name];
% labeld=dir([labelp,filesep,'*mat']);
% labeldpath=[labelpath,labeltemp(3).name,filesep,labeld.name];
mp_label=importdata(labelp);