clc
clear
path_allDir=dir('../../dataset/usemg/*');
for index_sub = 3:3 %length(path_allDir)
    path_dir = string(path_allDir(index_sub).folder)+"/"+string(path_allDir(index_sub).name);
    disp(path_dir)
    for i=1:1 %8 motions
        path_allData = dir(char(string(path_dir)+"/*.txt"));
        index=2*i-1;
        path_EMG = string(path_allData(index).folder)+"/"+string(path_allData(index).name);
        rawEMG=importdata(path_EMG); %肌电信号，有效通道为5~8
        index=2*i;
        path_US=string(path_allData(index).folder)+"/"+string(path_allData(index).name); %超声信号，有效通道为5~8
        rawUS = importdata(path_US);
        EMG_plot = rawEMG(5501:6500,6);
        US_plot = rawUS(55001:65000,6);
        US_plot = reshape(US_plot,1000,length(US_plot)/1000);
    end
    figure()
    plot(EMG_plot,'color',[0,104,55]/255.0,'linestyle','-','linewidth',1.5)
    set(gca,'YLim',[-200,200]);
    axis off;
    for i=1:size(US_plot,2)
        figure()
        plot(US_plot(:,i),'color',[165,0,38]/255.0,'linestyle','-','linewidth',1.5)
        axis off;
    end
    


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
    csvwrite("../../featureset/usemg/"+save_name,USFeature)
end


%ExFeature需要使用这些全局变量
global sampling_freq sample_length channel_num sample_depth sound_speed zero_delay frame_rate
%% Experiment & Data processing parameters
channel_num = 4;
motion_num = 1;
trial_num=15;
real_begin_time = 0;%second
holdtime_per_action = 33; %second
resttime_per_action = 0; %每个动作中间如果有间隔的休息时间，启用这个参数
totaltime_per_action = holdtime_per_action + resttime_per_action;
headtime = 0; %去掉过渡的时间（开头）
tailtime = 0; %去掉过渡的时间（结尾）
coretime_per_action = holdtime_per_action - headtime - tailtime; %second  每个动作的实际有效数据时间
resttime_per_trial = 0;%每个trial中最后的休息时间 seconds
totaltime_per_trial = totaltime_per_action * motion_num + resttime_per_trial;
win_length = 20; %特征提取窗长
start_channel =5;
end_channel =8;

%% Ultrasound device parameters
sample_dots = 1000;
sample_length = sample_dots; % num of dots sampled
sample_depth = 38.5e-3;
sample_depth = repmat(sample_depth, 1, channel_num);
sampling_freq = 20e6;
sampling_freq = repmat(sampling_freq, 1, channel_num);
zero_delay = 0e-6; 
sound_speed = 1540; % m/s
frame_rate = 10;


%% other Parameters
feature_num = frame_rate* coretime_per_action * motion_num * trial_num ;
frame_num = frame_rate  * holdtime_per_action * motion_num * trial_num;
foobar_raw = zeros(channel_num, sample_length);
fea_len = length(ExFeature(foobar_raw, win_length)); %特征长度
Feature(feature_num, fea_len) = 0;

%% data read
foobar_raw = load (data_path);
% foobar_raw = foobar_raw.myfoobar;
raw_frame_num = NaN;
raw_data = cell(1, channel_num); % videonum x channel_num
% raw_force = cell(1, 1);

if isnan(raw_frame_num) 
    raw_frame_num = floor(length(foobar_raw(:,1))/sample_dots);% first run in first loop
else                                                 
    if raw_frame_num ~= floor(length(foobar_raw(:,1))/sample_dots) % not first loop
        error 'line numbers not compatible.';
    end
end
display(['line number is ' num2str(raw_frame_num)]);
data_frame_num = raw_frame_num - real_begin_time * frame_rate;
foobar_raw = foobar_raw(1 + real_begin_time * frame_rate * sample_dots : raw_frame_num * sample_dots,start_channel:end_channel);
% data_frame_num = floor(length(foobar_raw(:,1))/sample_dots);

for ch_no = 1:channel_num  
    raw_data{1,ch_no} = reshape(foobar_raw(:,ch_no), sample_dots, data_frame_num)';
end

warning 'Remeber to check the length of each matrix!'
disp 'loading finishes '

raw_data_combine = cell(data_frame_num ,1);
disp 'start combining '
temp = zeros(channel_num, sample_dots);
for i = 1: data_frame_num
    for j = 1: channel_num
        temp(j,:) = raw_data{1, j}(i, :);
    end
    raw_data_combine{i, 1} = temp;
end
disp 'combine ending '
figure()
plot(raw_data_combine{1, 1}(2,:),'color','b','linestyle','-','linewidth',1.2)
hold on
plot(raw_data_combine{150, 1}(2,:),'color','m','linestyle','-','linewidth',1.2)
hold off
set(gca,'LineWidth',1.5,'FontWeight','bold');
%%
[processed_Signal1,USFeature1]=Ex_processedSignal_Feature(raw_data_combine{1, 1},win_length);
[processed_Signal2,USFeature2]=Ex_processedSignal_Feature(raw_data_combine{150, 1},win_length);
figure()
plot(processed_Signal1,'color','b','linestyle','-','linewidth',1.2)
hold on
plot(processed_Signal2,'color','m','linestyle','-','linewidth',1.2)
hold off
set(gca,'LineWidth',2.5,'FontWeight','bold','FontSize',20);
%%
raw_emg=importdata("../data/"+subject_name+"/EMG.txt");
emg_data=raw_emg(33001:66000,6);
force=importdata("../data/"+subject_name+"/force.txt");
force=force(33001:66000);
x_axis=33001:66000;


figure()
subplot(312)
plot(x_axis,emg_data,'color','g','linestyle','-','linewidth',1.5)
% xlabel('time/ms')
% ylabel('sEMG/mV')
set(gca,'LineWidth',1.5,'FontWeight','bold');
subplot(311)
plot(x_axis,force,'color','r','linestyle','-','linewidth',1.5)
% xlabel('time/ms')
% ylabel('force/kg')
set(gca,'LineWidth',1.5,'FontWeight','bold');
subplot(313)
x_axis2=33000.1:0.1:66000;
usdata=zeros(length(x_axis2),1);
for i=1:330
    usdata(1000*(i-1)+1:1000*i,1)=raw_data_combine{330+i,1}(2,:);
end
for i=33000:1000:45000 
    line([i,i],[0,100],'color',[0.2,0.2,0.2],'linestyle','--','linewidth',1.5)
end
for i=60000:1000:66000 
    line([i,i],[0,100],'color',[0.2,0.2,0.2],'linestyle','--','linewidth',1.5)
end
%plot(x_axis2,usdata,'color','b','linestyle','-','linewidth',1.5)
set(gca,'LineWidth',2.5,'FontWeight','bold','FontSize',20);