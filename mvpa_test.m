clear
clc
mvpa_mri = mvpa('.\test_data\data','.\test_data\label.txt','.\test_data\mask.mat',...
    'data_type','FC_map','subject_selection','balanced',[],...
    'feature_selection','Kmean',[40],'param_search','none',[],'normalization',...
    'zscore',[1],'classifier','linearSVM',[1],'fs_param_range',{[2,10,100]},...
    'cfier_param_range',{[1,0.00001,1000]},'fs_ps_ind',[1],'cfier_ps_ind',[1],...
    'cross_validation','kfold',[5]);
mvpa_mri.initial_path();
mvpa_mri.load_data();
mvpa_mri.load_params();
mvpa_mri.subject_selection();
mvpa_mri.normalization();
mvpa_mri.cross_validation();
mvpa_mri.classification();
disp(mvpa_mri.acc_best);

%%
clear
clc
mvpa_mri = mvpa('.\test_data\data','.\test_data\label.txt','.\test_data\mask.mat',...
    'data_type','FC_map','subject_selection','balanced',[],...
    'feature_selection','Kmean',[40],'param_search','PSO',[5],'normalization',...
    'zscore',[1],'classifier','linearSVM',[1],'fs_param_range',{[2,10,100]},...
    'cfier_param_range',{[1,0.00001,1000]},'fs_ps_ind',[1],'cfier_ps_ind',[1],...
    'cross_validation','Loocv',[5]);
mvpa_mri.initial_path();
mvpa_mri.load_data();
mvpa_mri.load_params();
mvpa_mri.subject_selection();
mvpa_mri.normalization();
mvpa_mri.cross_validation();
mvpa_mri.classification();
disp(mvpa_mri.acc_best);

clear
clc
mvpa_mri = mvpa('.\test_data\data','.\test_data\label.txt','.\test_data\mask.mat',...
    'data_type','FC_map','subject_selection','balanced',[],...
    'feature_selection','Lasso',[40,0.1],'param_search','PSO',[5],'normalization',...
    'zscore',[1],'classifier','linearSVM',[1],'fs_param_range',{[3,10,100];[1,1e-4,0.5]},...
    'cfier_param_range',{[1,0.00001,1000]},'fs_ps_ind',[1,1],'cfier_ps_ind',[1],...
    'cross_validation','kfold',[5]);
mvpa_mri.initial_path();
mvpa_mri.load_data();
mvpa_mri.load_params();
mvpa_mri.subject_selection();
label = mvpa_mri.label;
mvpa_mri.data(label == -1,:) = mvpa_mri.data(label == -1,:)+10;
mvpa_mri.normalization();
mvpa_mri.cross_validation();
mvpa_mri.classification();
disp(mvpa_mri.acc_best);

%%
clear
clc
mvpa_mri = mvpa('.\test_data\data','.\test_data\label.txt','.\test_data\mask.mat',...
    'data_type','FC_map','subject_selection','balanced',[],...
    'feature_selection','Lasso',[40,0.1],'param_search','grid_search',[],'normalization',...
    'zscore',[1],'classifier','linearSVM',[1],'fs_param_range',{[3,10,100],[1,0.0001,0.5]},...
    'cfier_param_range',{[1,0.0001,1000]},'fs_ps_ind',[1,1],'cfier_ps_ind',[1],...
    'cross_validation','Loocv',[5]);
mvpa_mri.initial_path();
mvpa_mri.load_data();
mvpa_mri.load_params();
mvpa_mri.subject_selection();
label = mvpa_mri.label;
mvpa_mri.data(label == -1,:) = mvpa_mri.data(label == -1,:)+10;
mvpa_mri.normalization();
mvpa_mri.cross_validation();
mvpa_mri.classification();
disp(mvpa_mri.acc_best);