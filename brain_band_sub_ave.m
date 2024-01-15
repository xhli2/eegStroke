%% 利用 brain_band_ave.m生成数据 将所有人溯源的pre或者post频带做平均 存为asc,,
clear ;close all
%%
preFile =dir(['D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\artric\data\' ...
    '溯源的频带的每个人的trial的平均\*\band_trial_pre_ave.asc']);
postFile =dir(['D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\artric\data\' ...
    '溯源的频带的每个人的trial的平均\*\band_trial_post_ave.asc']);

if length(preFile)~=length(postFile)
    error('the num of file is wrong')
end
%%
test = importdata(strcat(preFile(1).folder,'\band_trial_pre_ave.asc'));
[m,n] = size(test);
%% 所有人的pre 或者post
subNum= length(preFile);
pre_sub_trial = zeros(m,n,subNum);
post_sub_trial = zeros(m,n,subNum);
for i = 1:subNum
    pre_sub_trial(:,:,i) = importdata(strcat(preFile(i).folder,'\band_trial_pre_ave.asc'));
    post_sub_trial(:,:,i) = importdata(strcat(postFile(i).folder,'\band_trial_post_ave.asc'));
end

%% 做平均没有考虑相关的患侧或者健侧脑区
pre_sub_trial_ave = mean(pre_sub_trial,3);
post_sub_trial_ave = mean(post_sub_trial,3);

%% 保存
save_path = ['D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\artric\data\' ...
    '溯源的频带的每个人的trial的平均\所有人的'];
save_path_pre = strcat(save_path,'\pre');
save_path_post = strcat(save_path,'\post');
save(strcat(save_path_pre,'\band_sub_raw.mat'),'pre_sub_trial','pre_sub_trial_ave');
dlmwrite(fullfile(save_path_pre,'band_sub_pre_ave.asc'),pre_sub_trial_ave,'delimiter',' ','precision',7)

save(strcat(save_path_post,'\band_sub_raw.mat'),'post_sub_trial','post_sub_trial_ave');
dlmwrite(fullfile(save_path_post,'band_sub_post_ave.asc'),post_sub_trial_ave,'delimiter',' ','precision',7)


%% reletive power
%                    