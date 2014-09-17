clc;
clear all;
close all;
%%
% fid1 = fopen('p2.txt');
% result_blur = fscanf(fid1, '%g ', [1 inf]);
% figure
% p = plot(1:length(result_blur), result_blur); hold on; set(p,'Color','red','LineWidth',2);
% fclose(fid1);

%%
MAX_ITER = 50; %! !CHECK! this param before run!!
XLS_FILENAME = 'result-14-Sep-2014 20-50-06.xls';
SHOW_FLAG = 1;

max_diff = 0;
for i = 1 : MAX_ITER
    i
    [result{i} col_name{i}] = xlsread(XLS_FILENAME , ['sheet', num2str(i)] );
    observation_num = length(result{i});
    set1 = result{i}(1:observation_num/2, 4);
    set2 = result{i}(observation_num/2+1 : end, 4);    
    
    [TPR FPR T] = CalcRoc( set1, set2 )   
    diff(i) = abs(sum(set1 - T)) + abs(sum(set2 - T)); %norm([set1;set2]' - T);
    diff(i) = diff(i) * TPR * (1-FPR);
    
    if SHOW_FLAG
        
%         [ind] = find(result{i}(:,4) > T);
%         plot(ind, result{i}(ind,4),'--rs','LineWidth', 2, 'MarkerEdgeColor','g',...
%             'MarkerFaceColor', [0, 1, 0], 'MarkerSize', 5);hold on;
%         
%         [ind] = find(result{i}(:,4) <= T);
%         plot(ind, result{i}(ind,4),'--rs','LineWidth', 2, 'MarkerEdgeColor','r',...
%             'MarkerFaceColor', [1, 0, 0], 'MarkerSize', 5);hold on;

        plot(1:observation_num, result{i}(:,4),'--rs','LineWidth', 2, 'MarkerEdgeColor','r',...
            'MarkerFaceColor', [1, 0, 0], 'MarkerSize', 5);hold on;
        
        
        plot(1:observation_num, T); hold off;
        xlabel('video indx');
        ylabel('score, the more the normal');
        
    end
    
    clear TPR,clear FPR, clear T;
    %pause;
    
end

[maxdiff ind] = max(diff)
disp(['optimazation_param is in sheet ',num2str(ind)]);
   
figure;
[opt_result ~] = xlsread(XLS_FILENAME , ['sheet', num2str(ind)] );
observation_num = length(opt_result);
plot(1:observation_num, opt_result(:,4),'--rs','LineWidth', 2, 'MarkerEdgeColor','r',...
            'MarkerFaceColor', [1, 0, 0], 'MarkerSize', 5);hold on;title('best result');

set1 = opt_result(1:observation_num/2, 4);
set2 = opt_result(observation_num/2+1 : end, 4);    
[TPR FPR T] = CalcRoc( set1, set2 )




