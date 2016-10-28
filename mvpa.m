classdef mvpa < handle
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
        ss_path;
        di_path;
        % function_name
        cv_name = 'kfold';
        norm_name = 'none';
        fs_name = 'none';
        cfier_name = 'linearSVM';
        ps_name = 'none';
        ss_name = 'none';
        di_name = 'FC_map';
        % data_pathes
        data_path;
        label_path;
        mask_path = '';
        measure_path = '';
        output_path = '';
        % data
        data;
        data_info;
        label;
        mask;
        ss_extra;
        % input params
        cv_param = [];
        norm_param = [];
        fs_param = [];
        cfier_param = [];
        ps_param = [];
        fs_param_range = [];
        cfier_param_range = [];
        fs_ps_ind = [];
        cfier_ps_ind = [];
        
        % interal vars
        ss_idx;
        train_idx;
        test_idx;
        
        % output
        acc_best;
        label_unique;
        label_predict;
        score_predict;
        feature_weight;
        consensus_weight;
        classification_weight;
    end
    
    methods
        function obj = mvpa(varargin)
            obj.data_path = varargin{1};
            obj.label_path = varargin{2};
            if(nargin>2)
                obj.mask_path = varargin{3};
            end
            mvpa_path_tmp = mfilename('fullpath');
            obj.mvpa_path = mvpa_path_tmp(1:end-4);
            if(nargin>3)
                i = 4;
                while(i<nargin)
                    switch varargin{i}
                        case 'data_type'
                            i = i+1;
                            obj.di_name = varargin{i};
                        case 'subject_selection'
                            i = i+1;
                            obj.ss_name = varargin{i};
                            i = i+1;
                            obj.measure_path = varargin{i};
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
                        case 'fs_param_range'
                            i = i+1;
                            obj.fs_param_range = varargin{i};
                        case 'cfier_param_range'
                            i = i+1;
                            obj.cfier_param_range = varargin{i};
                        case 'fs_ps_ind'
                            i = i+1;
                            obj.fs_ps_ind = varargin{i};
                        case 'cfier_ps_ind'
                            i = i+1;
                            obj.cfier_ps_ind = varargin{i};
                        case 'output'
                            i = i+1;
                            obj.output_path = varargin{i};
                        otherwise
                            error(['wrong param: ',varargin{i}]);
                    end
                    i = i+1;
                end
            end
            obj.di_path = [obj.mvpa_path,'mvpa_data_import',...
                filesep,obj.di_name];
            obj.ss_path = [obj.mvpa_path,'mvpa_subject_selection',...
                filesep,obj.ss_name];
            obj.norm_path = [obj.mvpa_path,'mvpa_normalization',...
                filesep,obj.norm_name];
            obj.cv_path = [obj.mvpa_path,'mvpa_cross_validation',...
                filesep,obj.cv_name];
            obj.fs_path = [obj.mvpa_path,'mvpa_feature_selection',...
                filesep,obj.fs_name];
            obj.cfier_path = [obj.mvpa_path,'mvpa_classifier',...
                filesep,obj.cfier_name];
            obj.ps_path = [obj.mvpa_path,'mvpa_param_search',...
                filesep,obj.ps_name];
        end
        
        function initial_path(obj)
            old_path = path;
            old_path = textscan(old_path,'%s','Delimiter',';');
            old_path = old_path{1};
            for i = 1:length(old_path)
                curr_path = old_path{i};
                if(strfind(curr_path,[obj.mvpa_path,'mvpa_']))
                    rmpath(curr_path);
                end
            end
            addpath(obj.di_path);
            addpath(obj.ss_path);
            addpath(obj.norm_path);
            addpath(obj.cv_path);
            addpath(obj.fs_path);
            addpath(obj.cfier_path);
            addpath(obj.ps_path);
        end
        
        function load_data(obj)
            [obj.data,obj.label,obj.mask,obj.data_info] = mvpa_data_import(obj.data_path,...
                obj.label_path,obj.mask_path);
            if(~isempty(obj.measure_path))
                obj.ss_extra = load(obj.measure_path);
            end
        end
        
        function load_params(obj)
            if(isempty(obj.cv_param) &&...
                    exist([obj.cv_path,filesep,'param_default.txt'],'file'))
                obj.cv_param = load([obj.cv_path,filesep,'param_default.txt']);
            end
            if(isempty(obj.norm_param) &&...
                    exist([obj.norm_path,filesep,'param_default.txt'],'file'))
                obj.norm_param = load([obj.norm_path,filesep,'param_default.txt']);
            end
            if(isempty(obj.fs_param) &&...
                    exist([obj.fs_path,filesep,'param_default.txt'],'file'))
                obj.fs_param = load([obj.fs_path,filesep,'param_default.txt']);
            end
            if(isempty(obj.cfier_param) &&...
                    exist([obj.cfier_path,filesep,'param_default.txt'],'file'))
                obj.cfier_param = load([obj.cfier_path,filesep,'param_default.txt']);
            end
            if(isempty(obj.ps_param) &&...
                    exist([obj.ps_path,filesep,'param_default.txt'],'file'))
                obj.ps_param = load([obj.ps_path,filesep,'param_default.txt']);
            end
            if(isempty(obj.fs_param_range) &&...
                    exist([obj.fs_path,filesep,'param_range.txt'],'file'))
                param_range_tmp = load([obj.fs_path,filesep,'param_range.txt']);
                obj.fs_param_range = mat2cell(param_range_tmp,ones(1,size(param_range_tmp,1)));
            end
            if(isempty(obj.cfier_param_range) &&...
                    exist([obj.cfier_path,filesep,'param_range.txt'],'file'))
                param_range_tmp = load([obj.cfier_path,filesep,'param_range.txt']);
                obj.cfier_param_range = mat2cell(param_range_tmp,ones(1,size(param_range_tmp,1)));
            end
        end
        
        function subject_selection(obj)
            [obj.ss_idx,obj.label] = mvpa_subject_selection(obj.label,obj.ss_extra);
            %index must be converted to logical
            obj.ss_idx = logical(obj.ss_idx);
            obj.data = obj.data(obj.ss_idx,:);
        end
        
        function normalization(obj)
            obj.data = mvpa_normalization(obj.data,obj.label,obj.norm_param);
        end
        
        function cross_validation(obj)
            [obj.train_idx,obj.test_idx] = mvpa_cross_validation(obj.label,obj.cv_param);
        end
        
        function [data_train_f,apply_param,idx_weight_out] = feature_selection(obj,data_train,label_train)
            fs_param_tmp = obj.fs_param;
            for i = 1:length(fs_param_tmp)
                if(obj.fs_param_range{i}(1) == 2)
                    %1: continous param
                    %2: distinct param
                    %3: feature number
                    fs_param_tmp(i) = fix(fs_param_tmp(i));
                end
                if(obj.fs_param_range{i}(1) == 3)
                    fs_param_tmp(i) = fix(fs_param_tmp(i));
                    if(fs_param_tmp(i)<1)
                        fs_param_tmp(i) = 1;
                    elseif(fs_param_tmp(i)>size(obj.data,2))
                        fs_param_tmp(i) = size(obj.data,2);
                    end
                end
                if(fs_param_tmp(i) < obj.fs_param_range{i}(2))
                    fs_param_tmp(i) = obj.fs_param_range{i}(2);
                elseif(fs_param_tmp(i) > obj.fs_param_range{i}(3))
                    fs_param_tmp(i) = obj.fs_param_range{i}(3);
                end
            end
            [data_train_f,apply_param,idx_weight_out] = ...
                mvpa_feature_selection(data_train,label_train,fs_param_tmp);
        end
        
        function classification(obj)
            obj.label_predict = zeros(size(obj.data,1),1);
            obj.score_predict = zeros(size(obj.data,1),1);
            fs_weight = cell(length(obj.train_idx),1);
            for i = 1:length(obj.train_idx)
                disp(['classification: ',num2str(i),'/',num2str(length(obj.train_idx))]);
                data_train = obj.data(obj.train_idx{i},:);
                label_train = obj.label(obj.train_idx{i},:);
                data_test = obj.data(obj.test_idx{i},:);
                label_test = obj.label(obj.test_idx{i},:);
                
                [fs_param_best,cfier_param_best] = mvpa_param_search...
                    (data_train,label_train,obj.fs_param,obj.cfier_param,...
                    obj.fs_param_range,obj.cfier_param_range,obj.fs_ps_ind,obj.cfier_ps_ind);
                obj.fs_param = fs_param_best;
                obj.cfier_param = cfier_param_best;
                [data_train_f,apply_param,fs_weight{i}] = obj.feature_selection(data_train,label_train);
                data_test_f = mvpa_feature_selection_apply(data_test,label_test,apply_param);
                model = mvpa_classify(data_train_f,label_train,obj.cfier_param);
                [obj.label_predict(obj.test_idx{i}),obj.score_predict(obj.test_idx{i})] = mvpa_predict(data_test_f,label_test,model);
            end
            obj.acc_best(1) = sum(obj.label_predict == obj.label(:,1))./length(obj.label(:,1));
            obj.label_unique = unique(obj.label);
            for i = 1:length(obj.label_unique)
                obj.acc_best(i+1) = sum(obj.label_predict == obj.label_unique(i) ...
                    & obj.label(:,1) == obj.label_unique(i))...
                    ./sum(obj.label == obj.label_unique(i));
            end
            
            feature_weight_1d = zeros(size(fs_weight{1}));
            consensus_weight_1d = feature_weight_1d;
            % classification_weight_1d = feature_weight_1d;
            for i = 1:length(fs_weight)
                feature_weight_1d = feature_weight_1d+fs_weight{i};
                consensus_weight_1d(fs_weight{i}~= 0) = consensus_weight_1d(fs_weight{i}~= 0)+1;
                % classification_weight_1d = classification_weight_1d +
                % class_weight;
            end
            feature_weight_1d = feature_weight_1d./length(fs_weight);
            consensus_weight_1d = consensus_weight_1d./length(fs_weight);
            % classification_weight_1d =
            % classificcation_weight_1d./length(fs_weight);
            obj.feature_weight = zeros(size(obj.mask));
            obj.consensus_weight = zeros(size(obj.mask));
            obj.feature_weight(obj.mask ~= 0) = feature_weight_1d;
            obj.consensus_weight(obj.mask ~=0) = consensus_weight_1d;
        end
        
        function export_result(obj)
            [acc_total,label_out,acc_group,label_group] = obj.get_accuracy();
            sub_list = obj.get_subjects_used();
            fs_weight = obj.get_feature_weight();
            fs_consensus = obj.get_consensus_feature();
            mvpa_result_export(obj.output_path,acc_total,acc_group,label_group,label_out,...
                sub_list,fs_weight,fs_consensus,obj.data_info);
        end
        
        function [acc_total,label_out,acc_group,label_group] = get_accuracy(obj)
            acc_total = obj.acc_best(1);
            label_out = obj.label_predict;
            acc_group = obj.acc_best(2:end);
            label_group = obj.label_unique;
        end
        
        function score_classification = get_score_predict(obj)
            score_classification = obj.score_predict;
        end
        
        function sub_list = get_subjects_used(obj)
            subs = dir(obj.data_path);
            subs(1:2) = [];
            subs = subs(obj.ss_idx);
            sub_list = cell(length(subs),1);
            for i = 1:length(subs)
                sub_list{i} = subs(i).name;
            end
        end
        
        function fs_weight = get_feature_weight(obj)
            fs_weight = obj.feature_weight;
        end
        
        function fs_consensus = get_consensus_feature(obj)
            fs_consensus = obj.consensus_weight;
        end
        
        function main_path = get_mvpa_path(obj)
            main_path = obj.mvpa_path;
        end
        
    end
end