clc
clear
path_allData=dir('../dataset/S1/AUS/*.txt');
for i=1:8 %8 motions
    index=i;
    path_data=path_allData(index).name;
    path_folder=path_allData(index).folder;
    %rawEMG=importdata(string(path_allData(index).folder)+"/"+string(path_allData(index).name)); %�����źţ���Чͨ��Ϊ5~8
    path_US=string(path_allData(index).folder)+"/"+string(path_allData(index).name); %�����źţ���Чͨ��Ϊ5~8
%%   exactUSFeature Parameter:
%     path_US; 
%     trial_num;trial��Ŀ��ÿ��trial�����������
%     motion_num:����������
%     holdtime_per_action:ÿ������������ʱ��
%     resttime_per_action:%ÿ�������м�����м������Ϣʱ�䣬�����������
%     headtime:ȥ�����ɵ�ʱ�䣨��ͷ��
%     tailtime:ȥ�����ɵ�ʱ�䣨��β��
%     resttime_per_trial:%ÿ��trial��������Ϣʱ�� seconds
    USFeature=exactUSFeature(path_US,1,33,10,0,0,0,0);
    %��emgFeature����Ϊcsv
    save_name="Feature_"+path_data;
    csvwrite("../dataset/S1/AUS/"+save_name,USFeature)
end
