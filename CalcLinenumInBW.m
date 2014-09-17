function CalcLinenumInBW()
close all;

MAX_ITER = 10; %! !CHECK! this param before run!!
XLS_FILENAME = 'linenum_BWresult-14-Sep-2014 11-52-49.xls';
SHOW_FLAG = 1;

max_diff = 0;

for i = 1 : MAX_ITER
    i
    [result{i}] = xlsread(XLS_FILENAME , ['sheet', num2str(i)] );
    observation_num = length(result{i});
    set1 = result{i}(1:observation_num/2, :); % blur
    set2 = result{i}(observation_num/2+1 : end, :); % normal
    
    ind = find(set1(:,1)~=0); % should exist at least 1 line 
    line_point_ratio1 = set1(ind,2) ./ set1(ind,1);
    
    ind = find(set2(:,1)~=0); % should exist at least 1 line    
    line_point_ratio2 = set2(ind,2) ./ set2(ind,1);
    
    line_point_ratio(i) = mean([line_point_ratio2])
    
    plot(1:length(line_point_ratio2), [line_point_ratio2]','--rs','LineWidth', 2, 'MarkerEdgeColor','k',...
       'MarkerFaceColor', [1, 0, 0], 'MarkerSize', 5);hold on
    plot(1:length(line_point_ratio1), [line_point_ratio1]','--gs','LineWidth', 2, 'MarkerEdgeColor','g',...
       'MarkerFaceColor', [1, 0, 0], 'MarkerSize', 5);
    % pause;
end

mean(line_point_ratio)
% plot(1:length(line_point_ratio), [line_point_ratio]','--rs','LineWidth', 2, 'MarkerEdgeColor','k',...
%     'MarkerFaceColor', [1, 0, 0], 'MarkerSize', 5);

end