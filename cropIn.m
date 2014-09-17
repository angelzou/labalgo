function [ output ] = cropIn( input, crop_top, crop_bot )

%%
if ndims( input ) > 2
    output(:,:,1) = cropIn( input(:,:,1), crop_top, crop_bot );
    output(:,:,2) = cropIn( input(:,:,2), crop_top, crop_bot );
    output(:,:,3) = cropIn( input(:,:,3), crop_top, crop_bot ); 
else
    [M N ~] = size(input);
    ymin_up = floor( M * crop_top );
    ymin_down = floor( M * crop_bot );
    xmin = floor( N * 0.01  );
    rect_H= M - ymin_up - ymin_down;
    rect_W = N - xmin*2;
    rect = [xmin ymin_up rect_W rect_H];
    output = imcrop(input, rect);
end

end

