function [ Q_img ] = KMeansColorReduction( img )

%Input Parameters
noOfColors = 48;%Number of colors to be present in the output
%Warning
%The program execution time will be high, if noOfColors is greater than 64.

%Read Input Image
inImg = img;
s_img = size(inImg);

%K-Means
r = inImg(:,:,1);
g = inImg(:,:,2);
b = inImg(:,:,3);
inputImg = zeros((s_img(1) * s_img(2)), 3);
inputImg(:,1) = r(:);
inputImg(:,2) = g(:);
inputImg(:,3) = b(:);
inputImg = double(inputImg);
disp('K-Means Processing Started');
[idx, C] = kmeans(inputImg, noOfColors, 'EmptyAction', 'singleton');
disp('K-Means Processing Completed');
palette = round(C);

%Color Mapping
idx = uint8(idx);
outImg = zeros(s_img(1),s_img(2),3);
temp = reshape(idx, [s_img(1) s_img(2)]);
for i = 1 : 1 : s_img(1)
    for j = 1 : 1 : s_img(2)
        outImg(i,j,:) = palette(temp(i,j),:);
    end
end

Q_img = uint8(outImg);

end