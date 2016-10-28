function mvpa_run(mvpabatch)
mvpabatch.initial_path();
mvpabatch.load_data();
mvpabatch.load_params();
mvpabatch.subject_selection();
mvpabatch.normalization();
mvpabatch.cross_validation();
mvpabatch.classification();
mvpabatch.export_result();
disp(mvpabatch.acc_best);

end