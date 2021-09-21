clc
clear
path_allData=dir('../../dataset/usemg/S7/*.txt');
for i=1:8 %8 motions
    index=2*i;
    path_data=path_allData(index).name;
    path_folder=path_allData(index).folder;
    %rawEMG=importdata(string(path_allData(index).folder)+"/"+string(path_allData(index).name)); %肌电信号，有效通道为5~8
    path_US=string(path_allData(index).folder)+"/"+string(path_allData(index).name); %超声信号，有效通道为5~8
%%   exactUSFeature Parameter:
%     path_US; 
%     trial_num;trial数目，每个trial包含多个动作
%     motion_num:动作的种类
%     holdtime_per_action:每个动作持续的时间
%     resttime_per_action:%每个动作中间如果有间隔的休息时间，启用这个参数
%     headtime:去掉过渡的时间（开头）
%     tailtime:去掉过渡的时间（结尾）
%     resttime_per_trial:%每个trial中最后的休息时间 seconds
    USFeature=exactUSFeature(path_US,1,33,10,0,0,0,0);
    %将emgFeature保存为csv
    save_name="Feature_"+path_data;
    csvwrite("../../featureset/usemg/S7/"+save_name,USFeature)
end
