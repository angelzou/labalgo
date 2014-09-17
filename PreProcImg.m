function [ img ] = PreProcImg( img_orign )

%%
img_sized = imresize(img_orign, [288 352]);
if ndims( img_sized ) > 2
    img_gray = rgb2gray(img_sized);
else
    img_gray = img_sized;
end


%%
% [M N ~] = size(img_gray);
% ymin = floor( M * s_Param.CROP_RATIO );
% xmin = 0;%floor( N * crop_param  );
% rect_H= M - ymin*2;
% rect_W = N;% - xmin*2;
% rect = [xmin ymin rect_W rect_H];
% img_gray = imcrop(img_gray, rect);

img_gray = cropIn(img_gray, .15, .15);
img = img_gray;

end

