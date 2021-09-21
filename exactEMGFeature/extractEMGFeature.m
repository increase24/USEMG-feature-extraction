clc
clear
path_allData=dir('../../dataset/usemg/S7/*.txt');
for i=1:8 %8 motions
    index=2*i-1;
    path_data=path_allData(index).name;
    path_folder=path_allData(index).folder;
    rawEMG=importdata(string(path_allData(index).folder)+"/"+string(path_allData(index).name)); %肌电信号，有效通道为5~8
    %rawUS=importdata(string(path_allData(index_subject+1).folder)+"/"+string(path_allData(index_subject+1).name)); %超声信号，有效通道为5~8
    emgFeature=[TDAR6(rawEMG(:,5),250,100),TDAR6(rawEMG(:,6),250,100),TDAR6(rawEMG(:,7),250,100),TDAR6(rawEMG(:,8),250,100)];
    %将emgFeature保存为csv
    %S=regexp(path_data, '.', 'split');
    save_name="Feature_"+path_data;
    csvwrite("../../featureset/usemg/S7/"+save_name,emgFeature)
end



