function [ ImageMatrix NameMatrix ] = ReadVideoMatrix(DIRS, funhandle)
%%
PREPROC = logical(1);
if nargin == 1
    PREPROC = logical(0);
end


for i = 1 : length(DIRS)
    FILES = dir(fullfile(DIRS{i}, '*.avi'));
    FILENUM = size(FILES,1);
    for  j = 1 : FILENUM

        filename = FILES(j).name;
        aviObj = mmreader([DIRS{i},filename]);
        
        flag =['Read Into Memory: ', filename ]; disp(flag);
        img = read(aviObj, 5);
        
        if PREPROC
            img = {funhandle(img)};
        end
        
        ImageMatrix(i,j) = {img};
        NameMatrix(i,j) = {filename};
        
        % ImageMatrix(i,j) = imresize( , [288 352] );
        % img = cropIn(img, .15, .15);       
    end
    
    clear FILES;
    clear FILENUM;
end

end