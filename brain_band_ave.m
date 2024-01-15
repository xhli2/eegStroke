%%
% 1.为了将所有频带的trial.txt 中的信号先每个人的trial 先平均，
% 2.将同一区域的平均，可以看一下所有区域的
% 3.对比前后变化
% 4. 每个人的trial 响应频带的统计
% 5                                       .尝试每个人的trial 统计最大值再做统计

%%

clear ;close all

%% 对每个通道的数据平均_pre
prename ='zrp_0511';
postname = 'zrp_0601';
% text_file_path = strcat('D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\肌电脑电_ztrack\',prename,'\eegtrial_frqband\');
text_file_path = strcat('D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\肌电脑电_ztrack2\',prename,'\eegtrial_frqband\');

testname = dir(strcat(text_file_path,'*-slor.txt'));
% 对每个通道的数据平均_post
% text_file_path_post = strcat('D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\肌电脑电_ztrack\',postname,'\eegtrial_frqband\');
text_file_path_post = strcat('D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\肌电脑电_ztrack2\',postname,'\eegtrial_frqband\');
% save_Path_post = '';
testname_post = dir(strcat(text_file_path_post,'*-slor.txt'));
numtrial = min(length(testname),length(testname_post));
% test
text_name_t = 'trial_2-slor.txt';
file_t = importdata(strcat(text_file_path,text_name_t));
[m,n] = size(file_t);

%% 个人trial的提取
allTril_pre = zeros(m,n,numtrial);
allTril_post = zeros(m,n,numtrial);
% reltive = zeros(m,n,numtrial);
for i =1:numtrial
    text_trial_name = strcat('trial_',num2str(i),'-slor.txt');
    allTril_pre(:,:,i) = importdata(strcat(text_file_path,text_trial_name));
    allTril_post(:,:,i) = importdata(strcat(text_file_path_post,text_trial_name));
%     reltive(:,:,i) = allTril_pre(:,:,i)./sum(allTril_pre(:,:,i));
end

%% 做平均
allTril_pre_ave = mean(allTril_pre,3);
allTril_post_ave = mean(allTril_post,3);
% allrelpre_ave = mean(reltive,3);
% aat = allTril_pre_ave./sum(allTril_pre_ave);
%% save,将原始数据保存为mat及 前后平均后的为，txt
save_path = 'D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\artric\data\溯源的频带的每个人的trial的平均\';
save_path_pre = strcat(save_path,prename);
save_path_post= strcat(save_path,postname);
if ~isempty(save_path_pre)
    mkdir(save_path_pre)
end
if ~isempty(save_path_post)
    mkdir(save_path_post)
end
save(strcat(save_path_pre,'\band_trials_raw.mat'),'allTril_pre','allTril_pre_ave');
dlmwrite(fullfile(save_path_pre,'band_trial_pre_ave.asc'),allTril_pre_ave,'delimiter',' ','precision',7)

save(strcat(save_path_post,'\band_trials_raw.mat'),'allTril_post','allTril_post_ave');
dlmwrite(fullfile(save_path_post,'band_trial_post_ave.asc'),allTril_post_ave,'delimiter',' ','precision',7)