clc
clear
subject_name="ZJ";
emg_train="../split_data/"+subject_name+"/emg_train.csv";
emg_testA="../split_data/"+subject_name+"/emg_testA.csv";
force_train="../split_data/"+subject_name+"/force_train.csv";
force_testA="../split_data/"+subject_name+"/force_testA.csv";
X_train=cell(5,1);
y_train=cell(5,1);
X_testA=cell(5,1);
y_testA=cell(5,1);
nrmse=zeros(5,1);
r_square=zeros(5,1);
X_train{1,1}=emg_train(:,[1:4,11,12:15,22,23:26,33,34:37,44)
for i=1:3
    for j=1:3
        X_dataset{i,j}=importdata(path_X_dataset{i,j});
    end
    y_dataset{i,1}=importdata(path_y_dataset{i,1});
end
%%
result_nrmse=cell(3,2);
result_nrmse_3=cell(3,6);
result_nrmse_mean=cell(3,2);
result_nrmse_std=cell(3,2);
result_r2=cell(3,2);
result_r2_3=cell(3,6);
result_r2_mean=cell(3,2);
result_r2_std=cell(3,2);
for i=1:3
    X_train=X_dataset{i,1};
    y_train=y_dataset{1,1};
    X_testA=X_dataset{i,2};
    y_testA=y_dataset{2,1};
    X_testB=X_dataset{i,3};
    y_testB=y_dataset{3,1};
    %train the LS_SVM model
    type = 'function estimation';%regression or classification
    [gam,sig2] = tunelssvm({X_train,y_train,type,[],[],'RBF_kernel'},'simplex',...
    'leaveoneoutlssvm',{'mse'});                                 % depends on the data size
    [alpha,b] = trainlssvm({X_train,y_train,type,gam,sig2,'RBF_kernel'});
    %test the LS_SVM model
    y_predictA = simlssvm({X_train,y_train,type,gam,sig2,'RBF_kernel','preprocess'},{alpha,b},X_testA);%test output
    y_predictB = simlssvm({X_train,y_train,type,gam,sig2,'RBF_kernel','preprocess'},{alpha,b},X_testB);
    %[~, ~, ~, ~, STATUS]=regress((y_test), [(y_predict), ones( size(y_predict))]);
    %r_square1 = STATUS(1);
    [result_nrmse{i,1},result_r2{i,1}]=cal_nrmse_r2(y_predictA,y_testA);
    [result_nrmse{i,2},result_r2{i,2}]=cal_nrmse_r2(y_predictB,y_testB);
    for k=1:3
        y_predictA = simlssvm({X_train,y_train,type,gam,sig2,'RBF_kernel','preprocess'},{alpha,b},X_testA((k-1)*length(X_testA)/3+1:k*length(X_testA)/3,:));%test output
        [result_nrmse_3{i,1*k},result_r2_3{i,1*k}]=cal_nrmse_r2(y_predictA,y_testA((k-1)*length(y_testA)/3+1:k*length(y_testA)/3));
    end
    for k=1:3
        y_predictB = simlssvm({X_train,y_train,type,gam,sig2,'RBF_kernel','preprocess'},{alpha,b},X_testB((k-1)*length(X_testB)/3+1:k*length(X_testB)/3,:));
        [result_nrmse_3{i,1*k+3},result_r2_3{i,1*k+3}]=cal_nrmse_r2(y_predictB,y_testB((k-1)*length(y_testB)/3+1:k*length(y_testB)/3));
    end
%     figure()
%     plot(y_test,'r')
%     hold on 
%     plot(y_predict,'b')
%     hold off
end