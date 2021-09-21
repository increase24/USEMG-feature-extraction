clc
clear
path_allData=dir('../../dataset/*.txt');
for i=1:1 %8 subjects
    index=2*i-1;
    path_data=path_allData(index).name;
    path_folder=path_allData(index).folder;
    rawEMG=importdata(string(path_allData(index).folder)+"/"+string(path_allData(index).name)); %�����źţ���Чͨ��Ϊ5~8
    %rawUS=importdata(string(path_allData(index_subject+1).folder)+"/"+string(path_allData(index_subject+1).name)); %�����źţ���Чͨ��Ϊ5~8
    %emgFeature=[TDAR6(rawEMG(:,5),250,100),TDAR6(rawEMG(:,6),250,100),TDAR6(rawEMG(:,7),250,100),TDAR6(rawEMG(:,8),250,100)];
    %��emgFeature����Ϊcsv
%     S=regexp(path_data, '_', 'split');
%     save_name=string(S(1))+"_Feature_"+string(S(end));
%     csvwrite("../../featureset/"+save_name,emgFeature)
end
figure()
plot(rawEMG(10001:12000,5),'LineWidth',2.5)



