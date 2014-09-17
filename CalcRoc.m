%%
% true result set score, false set score, should be in range [0, 1]

function [TPR FPR T] = CalcRoc(t_set_score, f_set_score)

T = 0.2;%EstimateThresh( t_set_score .* 100, f_set_score .* 100) / 100;
TPR = sum(t_set_score < T ) / length( t_set_score );
FPR = sum(f_set_score < T ) / length( f_set_score );

end