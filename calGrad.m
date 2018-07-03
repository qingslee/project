% =========================================================================
function [grad, gradOri] = calGrad(img, mask, flag)
% -------------------------------------------------------------------------
% ����ָ���Ĳ�־���˼���x�����y������ݶ�(������ֵ�ͷ���)
% img-- Դͼ��
% mask-- ����x�����ݶȵĲ�־����(y����ľ������ת�ú�ȡ��)
% flag-- �ݶȷ������������ʶ
% @grad-- �ݶȷ�ֵ
% @gradOri-- �ݶȷ���
% -------------------------------------------------------------------------
assert(nargin==3);
xMask = mask;
yMask = -mask';
grad = zeros(size(img));
gradOri = zeros(size(img));
grad_x = imfilter(img, xMask);
grad_y = imfilter(img, yMask);
% �����ݶȷ�ֵ�ͷ����
grad = sqrt(double(grad_x.^2 + grad_y.^2));
if flag == 0
    % ���ݶȷ���ӳ�䵽����[0,pi]
    gradOri = atan(grad_y./(grad_x+eps));
    idx = find(gradOri<0);
    gradOri(idx) = gradOri(idx) + pi;
else
    % ���ݶȷ���ӳ�䵽����[0,2*pi]
    % ��һ����
    idx_1 = find(grad_x>=0 & grad_y>=0);
    gradOri(idx_1) = atan(grad_y(idx_1)./(grad_x(idx_1)+eps));
    % �ڶ�����������
    idx_2_3 = find(grad_x<0);
    gradOri(idx_2_3) = atan(grad_y(idx_2_3)./(grad_x(idx_2_3)+eps)) + pi;
    % ��������
    idx_4 = find(grad_x>=0 & grad_y<0);
    gradOri(idx_4) = atan(grad_y(idx_4)./(grad_x(idx_4)+eps)) + 2*pi;
end
end
% =========================================================================