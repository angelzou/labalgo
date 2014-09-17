function [bw] = DominateColor( I )
color_level = 12;
RGB_3_CHANL = 3;
NUM_COLOR = 85;

palette = getPalette( double(I), color_level );

pos = 1;
cnt = 1;
while cnt < NUM_COLOR
    [min_value index] = max( palette( : ) );
    [i, j, k] = ind2sub(size(palette), index);
    
    for flag = 1:length(i)
        data{pos} = [ i(flag), j(flag), k(flag), ...
            palette(i(flag), j(flag), k(flag)) ];
        pos = pos + 1;
    end
    palette(i, j, k) = 0;
    cnt = cnt + length(i);
end

mat_data = cell2mat(data');
mat_data = mat_data';
mat_data(1:3, :) = (mat_data(1:3, :)/color_level) * 255;
bar_img(:, :, 1) = mat_data(1, :);
bar_img(:, :, 2) = mat_data(2, :);
bar_img(:, :, 3) = mat_data(3, :);

bar_img = repmat(bar_img, 5, 1);
figure(1)
subplot(331);imshow(I);
bw = edge(rgb2gray(I), 'sobel');
subplot(334); imshow(bw);

subplot(333);bar(mat_data(4, :), 1);axis([0 90 0 15000])
subplot(336);imshow(uint8(bar_img));

S( 1:length(mat_data) ) = 0;
d = dist(mat_data);
freq = get_freq(mat_data(4, :));

for i = 1 : length(mat_data)
    for j =1 : length(mat_data)
        S(i) = S(i) + freq(j) * d(i,j);
    end
end

subplot(339); plot(1:length(S), S);

% pause();

end


%%
function [palette] = getPalette1( img, color_level )
eps = 0.001;
row = color_level * color_level * color_level;
palette(1:color_level , 1: color_level , 1:color_level) = -1;
cnt = 1;

[M N ~] = size(img);
for i = 1 : M
    for j = 1 : N
        
        r = min( ceil( (img(i, j , 1)/255 + eps) * color_level ), 12);
        g = min( ceil( (img(i, j , 2)/255 + eps) * color_level ), 12);
        b = min( ceil( (img(i, j , 3)/255 + eps) * color_level ), 12);
        
        palette(r,g,b) = palette(r,g,b) + 1;
    end
end

end

function [palette] = getPalette( img, color_level )
eps = 0.001;
row = color_level * color_level * color_level;
palette(1:color_level , 1: color_level , 1:color_level) = -1;
cnt = 1;

[M N ~] = size(img);
for i = 1 : M
    for j = 1 : N
        
        r = min( ceil( (img(i, j , 1)/255 + eps) * color_level ), 12);
        g = min( ceil( (img(i, j , 2)/255 + eps) * color_level ), 12);
        b = min( ceil( (img(i, j , 3)/255 + eps) * color_level ), 12);
        
        palette(r,g,b) = palette(r,g,b) + 1;
    end
end

end

function dist_lab( img )
[M N ~] = size(img);
cform = makecform('srgb2lab');
lab = applycform(img, cform);

dist(M,N) = 0;

for i = 1 : M
    for j = 1 : N
        l = lab(i, j, 1);
        a = lab(i, j, 2);
        b = lab(i, j, 3);

        for p = 1 : M
            for q = 1 : N
                l1 = lab(p, q, 1);
                a1 = lab(p, q, 2);
                b1 = lab(p, q, 3);
                temp = sqrt( (l-l1)^2 - (a-a1)^2 - (b-b1)^2 );
                dist(i, j) = dist(i, j) + temp;
            end
        end
        
    end
end

end

function [freq] = get_freq( mat_data )
l = length( mat_data );
total = sum( mat_data );
freq(1 : l) = 0;

for i = 1 : l
    freq(i) = mat_data(i) / total;
end

end

% d ÊÇ¾àÀë¾ØÕó
function [ d ] = dist(data_mat)
[L A B] = RGB2Lab(data_mat(1, :), data_mat(2, :), data_mat(3, :));
l = length(data_mat);
d(1:l, 1: l) = 0;

for i = 1 : l
    for j = 1 : l
        d(i, j) = sqrt( (L(i) - L(j))^2 + (A(i) - A(j))^2  + (B(i) - B(j))^2 );
    end
end

end



