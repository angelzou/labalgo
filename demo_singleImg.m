clc;
clear all;

close all;
FULL_NAME = 'D:\STUDY\[1] ÕºœÒ¥¶¿Ì\ ”∆µø‚ 4.0\exp temp\3-11_4_1397622731.avi';
aviObj = mmreader(FULL_NAME);


params.LENTHRESH = 78;
params.MAXLINEGAP = 9.8;
params.PPHT_VOTE_THRESH = 38.8;

for i = 1 : 25
    img = read(aviObj, i);
    img = PreProcImg(img);
    LookAtEdge(img, params, FULL_NAME);
end