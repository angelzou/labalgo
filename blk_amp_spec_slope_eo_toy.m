
function [res] = blk_amp_spec_slope_eo_toy(blk)

persistent N;
persistent wnd;

if (nargin == 0)
  N = [];
  wnd = [];
  return;
end

if (nargin == 2 || isempty(N))
  N = size(blk, 1);
  wnd = hanning(N);
  wnd = wnd * wnd';
end

if (~isa(blk, 'double'))
  blk = double(blk);
end
blk_wnd_prod = blk .* wnd;
% blk_wnd_prod = blk;
[fs, as] = eo_polaraverage(abs(fft2(blk_wnd_prod)));
fs = fs(1:end);
as = as(1:end);

figure(111);
subplot(121);
imshow(uint8(blk));
subplot(122);
plot(log(fs), log(as));
p = polyfit(log(fs), log(as), 1);
title( [ 'y = ', num2str(p(1)), 'x + ', num2str( p(2) ) ] );
pause();
res(1) = -p(1);
res(2) = p(2);

end