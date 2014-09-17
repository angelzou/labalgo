clc;
clear all;
close all;

% TODO
% 把OPTION = 1的霍夫变换弄好
% 调参
% +-样本参数扩大
% +-样本间距离度量
% +-计算线点比的方法：1不计算linenum=0的视频，因为linenum=0不会参与预测的计算；2只计算normal的视频，增加了模糊图像点线比的难度

%%
% FILEDIRS(:,1) = {'D:\STUDY\[1] 图像处理\视频库 4.0\exp temp\blur\', 'D:\STUDY\[1] 图像处理\视频库 4.0\exp temp\normal\'};
FILEDIRS(:,1) = {'D:\STUDY\[1] 图像处理\视频库 4.0\exp temp\blur\', 'D:\STUDY\[1] 图像处理\视频库 4.0\李军 temp\误报模糊\市局误报模糊视频\'};


XLS_FNAME = ['result-', strrep(datestr(now),':','-'),'.xls'];
MAX_ITER = 50;

%%
if ~( exist('ImageMatrix.mat')~=0 )  
    delete ImageMatrix.mat NameMatrix.mat; 
    [ImageMatrix NameMatrix] = ReadVideoMatrix(FILEDIRS, @PreProcImg); 
    save ('ImageMatrix', 'ImageMatrix', 'NameMatrix');
else
    load ImageMatrix;
end

ImageMatrix = reshape(ImageMatrix', 1, length(ImageMatrix)*2);
NameMatrix = reshape(NameMatrix', 1, length(NameMatrix)*2);

for iter = 1 : MAX_ITER % param gradient descent
    % stohastic_gradient_descent()
    params.LENTHRESH = 100 - iter*0.5;
    params.PPHT_VOTE_THRESH = 10;%(params.LENTHRESH)/4 - iter*.05;
    params.MAXLINEGAP = 8 - 0.05*iter;
    params.CANNY_HIGHTHRESH = 160 - 0.5*iter;
    
    for i = 1 : length(ImageMatrix) % proc positive and negative dataset
        i
        if( isempty(ImageMatrix{i}) ) break; end
        [list1(i, :), list2(i, :)] = LookAtEdge(cell2mat(ImageMatrix{i}), params, NameMatrix{i});
        % pause;
    end
    
    COL_NAMES = {['LENTHRESH (', num2str(params.LENTHRESH),')'],...
        ['MAXLINEGAP (', num2str(params.MAXLINEGAP ), ')'], ...
        ['PPHT_VOTE_THRESH (', num2str(params.PPHT_VOTE_THRESH), ')'], 'p2'};
    xlswrite(XLS_FNAME, COL_NAMES, ['sheet', num2str(iter)], 'A1');
    xlswrite(XLS_FNAME, list1, ['sheet', num2str(iter)], 'A2');
    xlswrite(['linenum_BW',XLS_FNAME], list2, ['sheet', num2str(iter)], 'A1');
    clear list;
    % WriteLog();
end


%% WriteLog
display('end of file, dubmping the result into the log');
disp('finish dubmping');
disp('Press any Key to continue');pause;
close all;
