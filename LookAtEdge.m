function [ list1, list2 ] = LookAtEdge(img_org, params, filename)

%%
CANNY_LOWTHRESH = 30;
CANNY_HIGHTHRESH = 100;
LENTHRESH =  params.LENTHRESH;%80;
MAXLINEGAP = params.MAXLINEGAP;%8;
PPHT_VOTE_THRESH = params.PPHT_VOTE_THRESH;%LENTHRESH/4;
SHOW_FLAG = 0;

log_index = 4;
log_name = {'blur.txt'; 'not_blur.txt'; 'p1.txt'; 'p2.txt'};
[M N ~] = size(img_org);

img_gray = [];
if ndims( img_org ) > 2
    img_gray = rgb2gray(img_org);
else
    img_gray = img_org;
end

w = fspecial('gaussian', [5 5], 3);
img_gray = imfilter(img_gray, w);

OPTION = 2 % 0 = MATLAB SHT, 1 = SHT, 2 = PPHT

%%
% MATLAB Version Canny Function ¡ý
% [BWCanny1 thresh] = edge(im2double(rgb2gray(img_filter)), 'canny', 0.5);%, [0.1 0.2][30/255 150/255]


% Opencv Version Canny Function ¡ý
% BWCanny1 = cv.Canny(img_gray, [30, 140]);
BWCanny1 = cv.Canny(img_gray, params.CANNY_HIGHTHRESH);
BWCanny1 = cropIn(BWCanny1, .02, .02);


lines = [];
switch (OPTION)
    case 0
        [H, T, R] = hough(BWCanny1, 'RhoResolution', 0.5, 'Theta', -90:0.5:89.5);
        P         = houghpeaks(H, LENTHRESH, 'threshold', 0);%ceil(0.3*max(H(:)))
        lines     = houghlines(BWCanny1, T, R, P, 'FillGap', 10, 'MinLength', LENTHRESH);
    case 1 % SHT
        lines_R_T = cv.HoughLines(BWCanny1);%, 'Threshold', LENTHRESH/4
        for i = 1 : length(lines_R_T)
            rho = lines_R_T{i}(1,1);
            theta = lines_R_T{i}(1,2);
            
            a = cos(theta), b = sin(theta);
            x0 = a*rho, y0 = b*rho;
            lines{i} = [round(x0 + 1000*(-b)), round(y0 + 1000*(a)),...
                round(x0 - 1000*(-b)), round(y0 - 1000*(a))];         
        end        
    case 2 % PPHT
        lines = cv.HoughLinesP(BWCanny1, 'Threshold', PPHT_VOTE_THRESH, ...
            'MinLineLength', LENTHRESH, 'MaxLineGap', MAXLINEGAP);
end

if SHOW_FLAG
    handle = figure(111);
    subplot(121);
    imshow(img_org); title(['origin img_filter', filename]);
    subplot(122);
    imshow(mat2gray(BWCanny1, [0 255])); title('canny img_filter');hold on;
    set(handle, 'Name','IMVL Debug Window','NumberTitle','off','position', get(0,'ScreenSize'));
end

contribution_rate = 0;
line_num = 0;
if (isempty( lines )) || (isstruct(lines) && isempty(struct2cell(lines)))% there is no line detected
    %pause;
else 
    for k = 1:length(lines)
        switch (OPTION)
            case 0 %  MATLAB SHT
                xy = [lines(k).point1; lines(k).point2];
                len(k) = norm(lines(k).point1 - lines(k).point2);
            case 1 %  SHT return value is rho and theta
                xy = reshape( (lines{k}+1)', 2, 2 )';
            case 2 % 2 = PPHT, output vector : (x1,y1,x2,y2)               
                xy = reshape( (lines{k}+1)', 2, 2 )';
        end
        
        if SHOW_FLAG
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

            % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
            plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
        end
    end
    
    line_num = length(lines);%= sum(len > LENTHRESH);
    k1 = sum(sum(BWCanny1~=0)) / (M*N);
    p1 = sum(sum(BWCanny1~=0)) / (M*N) / 0.03;
    %p1 = bound(p1, 1, 4);   
    p2 = line_num/p1;%bound(, 0, 1);
    
    contribution_rate = p2
    % pause;
end
list1 = {LENTHRESH, MAXLINEGAP, PPHT_VOTE_THRESH, contribution_rate};
list2 = {line_num, sum(sum(BWCanny1~=0))/(M*N) };
end

function [bound_value] = bound(value, down_bound, up_bound)

bound_value = max(min(value, up_bound), down_bound);

end