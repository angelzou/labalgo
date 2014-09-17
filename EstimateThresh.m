function T = EstimateThresh(A1, A2)

%%
avg1 = mean(A1(:));
avg2 = mean(A2(:));

if(avg1 < avg2);
    D1 = A1(:);
    D2 = A2(:);
else
    D1 = A2(:);
    D2 = A1(:);
end

%%
T1 = min(D1);
T2 = max(D2);
M1 = numel(D1);
M2 = numel(D2);
% P1 = M1/(M1+M2);
% P2 = M2/(M1+M2);

%%
t = 1;
valRange = T1 : T2;
fitness = zeros([numel(valRange),1]);
for k = valRange
    flag1 = (D1 >= k);
    flag2 = (D2 < k);
    E1 = sum(flag1>0) / M1;
    E2 = sum(flag2>0) / M2;
    fitness(t) = E1 + E2;
    t = t + 1;
end

[X,id1] = min(fitness); %lower bound
[X,id2] = min(flipud(fitness)); %upper bound

id = floor((id1 + (T2-T1+1-id2+1))/2);
T = valRange(id);
end