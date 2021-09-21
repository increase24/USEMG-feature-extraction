
clear
clc

%% experiment parameters set
global sample_dots fr_num frame_rate chnum

sample_dots = 8*1024;  % sample_dots of a frame
frame_rate =10;        
chnum = 4;
file_num = 1;
fr_num = NaN;
raw_data = cell(file_num, chnum); % videonum x chnum
raw_force = cell(file_num, 1); 
real_start_time = 5; %seconds 开头5秒的数据不要


%% load ultrasound and dynamometer
%file1
cd 'F:\001【科研项目】\【001】超声肌电一体化\实验分析20171011\000实验数据\森森'
file_list = dir('*1.bin');

tic
for file_no = 1 : file_num
    
    fr_num = NaN;  % some files may have different frame number
    %for ch_no = 1 : chnum
    for ch_no = 1:chnum
        fp = fopen([file_list(file_no).name(1:17) num2str(ch_no) '.bin'], 'r');
        foobar_raw = fread(fp);
        if isnan(fr_num)                                     % first run in first loop
            fr_num = floor(length(foobar_raw)/sample_dots)-real_start_time*frame_rate;
        else                                                 % not first loop
            if fr_num ~= floor(length(foobar_raw)/sample_dots)-real_start_time*frame_rate
                error 'line numbers not compatible.';
            end
        end
        display(['line number is ' num2str(fr_num)]);
        foobar_raw= foobar_raw(1+real_start_time*frame_rate*sample_dots : (fr_num+real_start_time*frame_rate)*sample_dots);
        result = reshape(foobar_raw, sample_dots, fr_num)';
        fclose(fp);
        raw_data{file_no , ch_no} = result;
    end
end
toc
warning 'Remeber to check the length of each matrix!'
disp 'loading finishes '

%%数据预处理，舍去开头5s的数据



%%combine raw data
raw_data_combine = cell(fr_num ,1);
disp 'start combining '
temp = zeros(chnum, sample_dots);
for i = 1: fr_num
   for j = 1: chnum
       temp(j,:) = raw_data{1, j}(i, :);
   end
   raw_data_combine{i, 1} = temp;
end
disp 'combine ending '
cd  'F:\001【科研项目】\【001】超声肌电一体化\实验分析20171011\002超声识别分析';