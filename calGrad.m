% =========================================================================
function [grad, gradOri] = calGrad(img, mask, flag)
% -------------------------------------------------------------------------
% 利用指定的差分卷积核计算x方向和y方向的梯度(包括幅值和方向)
% img-- 源图像
% mask-- 计算x方向梯度的差分卷积核(y方向的卷积核是转置后取反)
% flag-- 梯度方向隐射区间标识
% @grad-- 梯度幅值
% @gradOri-- 梯度方向
% -------------------------------------------------------------------------
assert(nargin==3);
xMask = mask;
yMask = -mask';
grad = zeros(size(img));
gradOri = zeros(size(img));
grad_x = imfilter(img, xMask);
grad_y = imfilter(img, yMask);
% 计算梯度幅值和方向角
grad = sqrt(double(grad_x.^2 + grad_y.^2));
if flag == 0
    % 将梯度方向映射到区间[0,pi]
    gradOri = atan(grad_y./(grad_x+eps));
    idx = find(gradOri<0);
    gradOri(idx) = gradOri(idx) + pi;
else
    % 将梯度方向映射到区间[0,2*pi]
    % 第一象限
    idx_1 = find(grad_x>=0 & grad_y>=0);
    gradOri(idx_1) = atan(grad_y(idx_1)./(grad_x(idx_1)+eps));
    % 第二（三）象限
    idx_2_3 = find(grad_x<0);
    gradOri(idx_2_3) = atan(grad_y(idx_2_3)./(grad_x(idx_2_3)+eps)) + pi;
    % 第四象限
    idx_4 = find(grad_x>=0 & grad_y<0);
    gradOri(idx_4) = atan(grad_y(idx_4)./(grad_x(idx_4)+eps)) + 2*pi;
end
end
% =========================================================================