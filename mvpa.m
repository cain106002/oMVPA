classdef mvpa
    %MVPA class
    %   此处显示详细说明
    
    properties (SetAccess = public)
        % functiaon_pathes
        mvpa_path;
        cv_path;
        norm_path;
        fs_path;
        cfier_path;
        ps_path;
        % function_name
        cv_name = 'kfold';
        norm_name = '';
        fs_name = '';
        cfier_name = 'linearSVM';
        ps_name = '';
        % data_pathes
        data_path;
        label_path;
        mask_path = '';
        % data
        data;
        label;
        mask;
        % params
        cv_param = [5];
        norm_param = [];
        fs_param = [];
        cfier_param = [1];
        ps_param = [];
        train_idx;
        test_idx;
    end
    
    methods
        function obj = mvpa(varargin)
            obj.data_path = varargin{1};
            obj.label_path = varargin{2};
            if(nargin>2)
                obj.mask_path = varargin{3};
            end
            mvpa_path_tmp = which('mvpa');
            obj.mvpa_path = mvpa_path_tmp(1:end-6);
            if(nargin>3)
                i = 4;
                while(i<nargin)
                    switch varargin{i}
                        case 'cross_validation'
                            i = i+1;
                            obj.cv_name = varargin{i};
                            i = i+1;
                            obj.cv_param = varargin{i};
                        case 'normalization'
                            i = i+1;
                            obj.norm_name = varargin{i};
                            i = i+1;
                            obj.norm_param = varargin{i};
                        case 'feature_selection'
                            i = i+1;
                            obj.fs_name = varargin{i};
                            i = i+1;
                            obj.fs_param = varargin{i};
                        case 'classifier'
                            i = i+1;
                            obj.cfier_name = varargin{i};
                            i = i+1;
                            obj.cfier_param = varargin{i};
                        case 'param_search'
                            i = i+1;
                            obj.ps_name = varargin{i};
                            i = i+1;
                            obj.ps_param = varargin{i};
                        otherwise
                            error(['wrong param: ',varargin{i}]);
                    end
                    i = i+1;
                end
            end
            obj.cv_path = [obj.mvpa_path,'mvpa_cross_validation',...
                filesep,obj.cv_name];
            obj.norm_path = [obj.mvpa_path,'mvpa_normalization',...
                filesep,obj.norm_name];
            obj.fs_path = [obj.mvpa_path,'mvpa_feature_selection',...
                filesep,obj.fs_name];
            obj.cfier_path = [obj.mvpa_path,'mvpa_classifier',...
                filesep,obj.cfier_name];
            obj.ps_path = [obj.mvpa_path,'mvpa_param_search',...
                filesep,obj.ps_name];
        end
        
        function obj = load_data(obj)
            subs = dir(obj.data_path);
            subs(1:2) = [];
            for i = 1:length(subs)
                sub_name = subs(i).name;
                mat_file = dir([obj.data_path,filesep,sub_name,filesep,'*.mat']);
                nii_file = dir([obj.data_path,filesep,sub_name,filesep,'*.nii']);
                img_file = dir([obj.data_path,filesep,sub_name,filesep,'*.img']);
                if((isempty(mat_file)+isempty(nii_file)+isempty(img_file)) ~= 2)
                    error('more than 1 data type in the subjects');
                end
                if(length(mat_file) == 1)
                    var_struct = whos('-file',[obj.data_path,filesep,...
                        sub_name,filesep,mat_file.name]);
                    if(length(var_struct)~=1)
                        error('more than 1 var in the mat file');
                    end
                    if(~exist('mask','var'))
                        if(isempty(obj.mask_path))
                            obj.mask = ones(var_struc.size);
                        else
                            obj = load_mask(obj);
                        end
                    end
                    var_name = var_struct.name;
                    mat_var = load([obj.data_path,filesep,...
                        sub_name,filesep,mat_file.name]);
                    eval(['data_tmp = mat_var.',var_name,';']);
                    obj.data(i,:) = data_tmp(obj.mask == 1)';
                elseif(length(nii_file) == 1)
                    
                elseif(length(img_file) == 1)
                    
                else
                    
                end     
            end
        end
        
        function obj = load_label(obj)
            obj.label = load(obj.label_path);
        end
        
        function obj = load_mask(obj)
            if(strcmp(obj.mask_path(end-2:end),'mat'))
                mask_tmp = load(obj.mask_path);
                obj.mask = mask_tmp.mask;
%                 if(sum(size(obj.mask) ~= var_size)>0)
%                     error('dismatch of data and mask');
%                 end
            end
        end
        
        function obj = initial_path(obj)
            addpath(obj.cv_path);
            if(~isempty(obj.norm_name))
                addpath(obj.norm_path);
            end
            if(~isempty(obj.fs_name))
                addpath(obj.fs_path);
            end
            addpath(obj.cfier_path);
            if(~isempty(obj.ps_name))
                addpath(obj.ps_path);
            end
        end
            
        function obj = cross_validation(obj)
            [obj.train_idx,obj.test_idx] = mvpa_cross_validation(obj.label,obj.cv_param);
        end
        
        function obj = normalization(obj)
            if(isempty(obj.norm_name))
                return
            end
            obj.data = mvpa_normalization(obj.data,obj.label,obj.norm_param);
        end
        
        function obj = feature_selection(obj,varargin)
            if(isempty(obj.fs_name))
                return
            end
        end
        
        function obj = classification(obj)
            for i = 1:length(obj.train_idx)
                data_train = obj.data(obj.train_idx{i},:);
                label_train = obj.label(obj.train_idx{i});
                data_test = obj.data(obj.test_idx{i},:);
                label_test = obj.label(obj.train_idx{i});
                if(isempty(obj.ps_name) && isempty(obj.fs_name))
                    
                    return
                end
                if(isempty(obj.ps_name) && ~isempty(obj.fs_name))
                    
                    return
                end
                
                
                    
                
            end
        end
        
        function [fs_param_best,cfier_param_best] = param_search(obj,varargin)
            if(isempty(obj.ps_name))
                fs_param_best = obj.fs_param;
                cfier_param_best = obj.cfier_param;
                return
            end
        end
    end
end

