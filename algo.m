% function [s_map1 s_map2 s3] = s3_map(img, show_res)
function [s_map1 ] = algo(img, show_res)

if nargin < 2
    show_res = 0;
end

% ----------------------------------------------------------------------
% blr_map1
s_map1 = spectral_map(img, 16);

% %-----------------------------------------------------------------------
% % blr_map2
% s_map21 = spatial_map(img, 8); % Spatial map, blocks start from (1,1)
% % s_map22 = spatial_map(img, 4); % Spatial map, blocks start from (5,5)
% s_map2 = s_map21;%max(s_map21, s_map22);
%
% %-----------------------------------------------------------------------
% % combine
% s_map1(s_map1 < -99) = 0;
% s_map2(s_map2 < -99) = 0;
%
% alpha = 0.5;
% s3 = s_map2;%(s_map1.^alpha) .* ((s_map2).^(1-alpha));
if show_res
    figure; imshow(s_map1);
    figure; imshow(s_map2);
    figure; imshow(img/255);
    figure; imshow(s3);
end
end %function


%% Spectral Sharpness, slope of power spectrum
function res = spectral_map(img, pad_len)
[M N ~] = size(img);
blk_size = M/2; %big block size for more coefficients of the power spectrum
d_blk = blk_size/3; % Distance b/w blocks

num_rows = size(img, 1);
num_cols = size(img, 2);
res = zeros(num_rows, num_cols) - 100;
 [bw] = DominateColor(img);
        LookAtEdge(img, bw);
% for r = blk_size/2+1:d_blk:num_rows-blk_size/2 
%     
%     for c = blk_size/2+1:d_blk:num_cols-blk_size/2
%         blk = img(...
%             r-blk_size/2:r+blk_size/2-1,...
%             c-blk_size/2:c+blk_size/2-1, ...
%             :);
%         
%         [bw] = DominateColor(blk);
%         LookAtEdge(blk, bw);
%         
%     end
% end
% Remove padded parts
res = res(pad_len+1:end-pad_len-1, pad_len+1:end-pad_len-1);
end % function

%% ---Spatial Sharpness, local total variation
function res = spatial_map(img, pad_len)
% pad_len = 8 if we dont want to shift img
% pad_len = 4 if we want to shift img by 4;
blk_size = 8;

pad_L = fliplr(img(:, 1:pad_len)); % Take pad_len columns on the left of
% the original image to pad to the left
pad_R = fliplr(img(:, end-pad_len:end));%Take pad_len columns on the right
% of the original image to pad to the right
img = [pad_L img pad_R]; %Pad left and right

pad_T = flipud(img(1:pad_len, :)); %Similarly, pad top and bottom
pad_B = flipud(img(end-pad_len:end, :));
img = [pad_T; img; pad_B];

[num_rows, num_cols] = size(img);
res = zeros(num_rows, num_cols);

for r = blk_size/2+1 : blk_size : num_rows-blk_size/2
    for c = blk_size/2+1 : blk_size : num_cols-blk_size/2
        gry_blk = img(...
            r-blk_size/2 : r+blk_size/2-1,...
            c-blk_size/2 : c+blk_size/2-1 ...
            );
        % Measure local total variation for every 2x2 block of gry_blk
        tmp_idx = 1;
        for i = 1 : blk_size - 1
            for j = 1 : blk_size - 1
                tv_tmp(tmp_idx) = (abs(gry_blk(i,j) - gry_blk(i,j+1))...
                    + abs(gry_blk(i,j) - gry_blk(i+1,j))...
                    + abs(gry_blk(i,j) - gry_blk(i+1,j+1))...
                    + abs(gry_blk(i+1,j+1) - gry_blk(i+1,j))...
                    + abs(gry_blk(i+1,j) - gry_blk(i,j+1))...
                    + abs(gry_blk(i+1,j+1) - gry_blk(i,j+1)))/255; %Each pixel ranges
                %from 0 - 255, so divide by 255 to make it from 0 - 1
                tmp_idx = tmp_idx + 1;
            end
        end
        
        tv_max = max(tv_tmp) / 4; % Normalize tv_max to be from 0 -1. We can
        % easily see that the maximum value of total
        % variation for each 2x2 block is 4, in
        % blocks like   1 0
        %               0 1
        
        res(...
            r - blk_size/2 : r + blk_size/2-1,...
            c - blk_size/2 : c + blk_size/2-1 ...
            ) = tv_max;
    end
end
res = res(pad_len + 1 : end-pad_len - 1, pad_len + 1 : end-pad_len - 1);

end % function


