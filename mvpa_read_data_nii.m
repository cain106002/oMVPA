function [mp_data,mp_label] = mvpa_read_data_nii(mp_input_param)
%% lizhiqiang 2016/6/2
%% 读取nii数据，导入到app中
%% mp_input_param是输入的结构体，包括数据类型，数据位置,mask位置，label位置

%% 读取数据
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
    if(isempty(d)) %路径下是文件
    [data,~] =rest_ReadNiftiImage(p);%读取数据
    else % 路径下是文件夹
    dpath=[path,filesep,temp(i).name,filesep,d.name];%构造数据路径
    [data,~] =rest_ReadNiftiImage(dpath);%读取数据
    end
    data=reshape(data,size(data,1)*size(data,2)*size(data,3),size(data,4));
    mp_data(i,:)=data.*maskdata;
 end
%% 读取标签:标签文件夹只存放一个mat文件！！！
labelpath=mp_input_param.label_path;
labeltemp=dir(labelpath);
labeltemp=labeltemp(3);
labelp=[labelpath,filesep,labeltemp.name];
% labeld=dir([labelp,filesep,'*mat']);
% labeldpath=[labelpath,labeltemp(3).name,filesep,labeld.name];
mp_label=importdata(labelp);