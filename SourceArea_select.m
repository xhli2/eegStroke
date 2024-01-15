%% 为了将source的区域做平均
clear;close all
%% ROI设定
% Brodmann_area = [1,2,3,4];% 自己设置几个ROI区域
Brodmann_area = [1,2,3,4,6];% 自己设置几个ROI区域r
%%% 为了ROI的使用，方便用于与同侧及对侧的脑区的应用
%应该重新划定ROI的使用 
% 暂时可以用ROI,后面可以用直接设定L或者R的 Brodmann的脑区来设定平均该区域的源信号
filepath_roi = 'D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\肌电脑电_ztrack\channnel';
roicsvname ='ROI_right_label-ROI.csv';
roicsv = importdata(fullfile(filepath_roi,roicsvname));
[mr,nr] = size(roicsv);
roiarea = roicsv.data;
roiBarea = roicsv.textdata;
% maxroi = max(roiarea);% 有几类
roiBareab = roiBarea(4:end,6); % Brodmann area名称
SourceNum = length(roiarea);
%
%%% 可以知道 左侧的x左边都是小于0的，右侧Brodmann area为>= 0,可以以此来确定左右脑的区域 
x_axis = roiBarea(4:end,1);
x_c = cellfun(@(x) str2double(x), x_axis); %x_c 为坐标
x_c_left = find(x_c<0);    %左脑区域
x_c_right = find(x_c>=0);  %右脑区域
%%% 设定的Brodmann area 区域
%%脑区左右的选择为根据hands 参数设定对应区域

numBrodmann = length(Brodmann_area);
brain_indx = cell(1,numBrodmann);
nn = {32};
%%% 现在只看对应脑区

%%% ROI 在溯源之后的idx ,leftBrain_indx及rightBrain_indx 用于不同的时刻
leftBrain_indx = cell(1,numBrodmann);
rightBrain_indx = cell(1,numBrodmann);
% Brain_indx_all = cell(1,numBrodmann);
for i = 1:numBrodmann
    B_area = Brodmann_area(i);
    a = ismember(roiBareab,strcat('Brodmann area',nn,num2str(B_area)));
    indx_t = find(a == 1);
    %表示患者为左手障碍，需要右侧脑区
    indx_t_r = intersect(x_c_right,indx_t);
    indx_t_l = intersect(x_c_left,indx_t);
    leftBrain_indx{i}= indx_t_l;
    rightBrain_indx{i} = indx_t_r;
end
Brain_indx_all = [leftBrain_indx,rightBrain_indx];% 全脑的roi 区域左右侧index
Brain_indx_name = {'leftBrain_indx','rightBrain_indx'};
%% 现在分别有左右的数据，需要对各个区域做平均

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
% pre_sub_trial_area = zeros(m,n,subNum);
% post_sub_trial_area = zeros(m,n,subNum);
allnumBrodmann = length(Brain_indx_all);
% save_path = ['D:\win\zjlab\肌电信号分解\肌电信号采集\脑电+肌电\artric\data\' ...
%     '溯源的频带的每个人的trial的平均\所有人的'];
for i = 1:subNum
    pre_sub_trial= importdata(strcat(preFile(i).folder,'\band_trial_pre_ave.asc'));
    post_sub_trial = importdata(strcat(postFile(i).folder,'\band_trial_post_ave.asc'));
    temp_pre = zeros(m,n);
    temp_post = zeros(m,n);
    temp_ave_pre = zeros(m,allnumBrodmann);
    temp_ave_post = zeros(m,allnumBrodmann);
    for i_r = 1:allnumBrodmann 
        %     for i_r = 5
        % 每个trial的脑电在相应的脑区的平均
        indx_T = Brain_indx_all{i_r};
        % 对区域内的eeg做平均
        Seeg_Roi_pre = mean(pre_sub_trial(:,indx_T),2);
        temp_pre(:,indx_T) = Seeg_Roi_pre.*ones(m,length(indx_T));
        temp_ave_pre(:,i_r) = Seeg_Roi_pre;
        Seeg_Roi_post = mean(post_sub_trial(:,indx_T),2);
        temp_post(:,indx_T) = Seeg_Roi_post.*ones(m,length(indx_T));
        temp_ave_post(:,i_r) = Seeg_Roi_post;
    end
    %% 保存

    save_path_pre = strcat(preFile(i).folder,'\band_BrodmannROI_ave');
    save_path_post = strcat(postFile(i).folder,'\band_BrodmannROI_ave');
    if ~isempty(save_path_pre)
        mkdir(save_path_pre)
    end
    if ~isempty(save_path_post)
        mkdir(save_path_post)
    end    
    save(strcat(save_path_pre,'\band_pre_BrodmannROI_ave.mat'),'temp_ave_pre','Brain_indx_name',"Brodmann_area",'temp_pre');
    dlmwrite(fullfile(save_path_pre,'band_pre_BrodmannROI_ave.asc'),temp_pre,'delimiter',' ','precision',7)

    save(strcat(save_path_post,'\band_post_BrodmannROI_ave.mat'),"temp_ave_post",'Brain_indx_name',"Brodmann_area",'temp_post');
    dlmwrite(fullfile(save_path_post,'band_post_BrodmannROI_ave.asc'),temp_post,'delimiter',' ','precision',7)

    clear post_sub_trial pre_sub_trial 
end