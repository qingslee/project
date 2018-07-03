function [hog_Feature] = HOG(detectedImg, options)
% -------------------------------------------------------------------------
% ʵ��HOG��Histogram of gradient����������ȡ���?
%
% detectedImg-- ��ⴰ�ڰ��ͼ�񣨻Ҷ�ͼ��
% options-- ����ṹ�壬�����������ã�?
%            cellH, cellW����Ԫ��С  
%            blockH, blockW������?
%            winH, winW����ⴰ�ڴ��?   
%            stride�����ƶ�����
%            bins��ֱ��ͼ����    
%            flag���ݶȷ����������?:[0,pi],1:[0,2*pi]��
%            epsilon: ��������һ���ĳ�������
% @hog_Feature-- ��ⴰ��ͼ���Ӧ��HOG������������СΪ1*M������
%    M = ((winH-blockH)/stride+1)*((winW-blockW)/stride+1)...
%        *(blockW/cellW)*(blockH/cellH) * bins
%
% HOG������ȡ���裺
% ----------------
% step 1.����Dalal���������ᵽɫ�ʺ�٤���һ����������յĽ��û��Ӱ�죬��ʡ�Ըò���?
% ����[-1,0,1]��[1,0,-1]'�ֱ����ͼ���x�����y������ݶ�?���ﲻ����Sobel��������
% ��Ե�����������ݶȣ�����Ϊ���Ƕ�ͼ������ƽ������������ݶȣ�����ᶪʧ�ܶ��ݶ���Ϣ��
% Ȼ�����ÿ�����ص��Ӧ���ݶȷ�ֵ�ͷ���
%    ||grad|| = |grad_x| + |grad_y|����||grad|| = sqrt(grad_x^2+grad_y^2)��
%    gradOri = arctan(grad_y/grad_x) ��gradOri����(-pi/2,pi/2)��
% �ڸ�ݲ���flag��ÿ�����ص���ݶȷ���ӳ�䵽��Ӧ�����,���flagΪ0��ѡ�����[0,pi]
% λ��(i,j)λ�����ص�ķ����? 
%       gradOri(i,j)=gradOri(i,j)<0?gradOri(i,j)+pi, gradOri(i,j)��
% ���flagΪ1ѡ�����Ϊ[0,2*pi],��ʱ��Ҫ���grad_x��grad_y�������жϣ�
%  (1)grad_x>=0&&grad_y>=0(��һ����) gradOri(i,j)=arctan(grad_y/grad_x)��
%  (2)grad_x<0&&grad_y>=0(�ڶ�����)  gradOri(i,j)=arctan(grad_y/grad_x)+pi��
%  (3)grad_x<0&&grad_y<0(��������)   gradOri(i,j)=arctan(grad_y/grad_x)+pi��
%  (4)grad_x>=0&&grad_y<0(��������)  gradOri(i,j)=arctan(grad_y/grad_x)+2*pi��
% ------------------
% step 2.Ϊ�˱�����⣬ֱ��д���Ĳ�ѭ������������ѭ����λblock,�������㶨λcell;
% һ��block��Ӧ(blockH*blockW/(cellH*cellW)*bins������������ÿ��cell��Ӧ1*bins
% ��ֱ��ͼ������block��ֱ��ͼ�ں���calHist����ɣ��������ֱ��ͼ��Ҫע�����㣺
% (1)����cellֱ��ͼʱ��������ص��ݶȷ�ֵ����ȨֵͶӰ��ͶӰʱ��������䷽ʽ����
% ���ò�ֵ�ķ�ʽ����ͶӰ������ݶȷ���������������������ĵ�ľ�����в�ֵ��
% (2)Dalal���������ᵽ������R-HOG���ԣ�����ֱ��ͼǰ�������block����һ����˹����
% ������Խ���block�߽����ص��Ȩ�أ�ֱ��ͼͶƱֵ��ԭ�ȵķ�ֵ��Ϊ��ֵ�͸�˹�˻�?
% (3)���blockֱ��ͼ�ļ������Ҫ�����block��Χ�ڽ���ֱ��ͼ��һ����������һ��
% ��ʽ�ж��֣�����Ĭ�ϲ���L2-norm(hist=hist/sqrt(hist^2+epsilon^2)).
% ------------------
% step 3.�ϲ���ⴰ���е�����block��������HOG����������
%
% ע�������̻��漰��һЩϸ�ڣ����絼��ͼ��߶Ⱥ����õļ�ⴰ�ڴ�С��ͬʱ����Ҫ
% ��ɳ߶����ţ�����ͼ���ݶ�ʱ���߽�������δ��?��ֱ�����?���Ǹ��Ʊ߽磬����
% ֱ�����?�����һ������ڼ���blockֱ��ͼʱ��û�н�����ά��ֵ����ÿ����Ԫ�е���
% �ص�ֻ�Ըõ�Ԫ��ͶƱ��Ȩ�����Ե�ǰblock������Ԫû��Ӱ�졣
%
% Author: L.L.He
% Time: 6/8/2014
% -------------------------------------------------------------------------
tic;
assert(nargin>=1);
if ~exist('options', 'var')
    % ������û��ָ����������Ϊ����Ĭ��ֵ
    options = struct;
    options.cellH = 8;   options.cellW = 8;
    options.blockH = 16; options.blockW = 16;
    options.winH = 32;   options.winW = 256;
    options.stride = 8;  options.bins = 9;
    options.flag = 1;    options.epsilon = 1e-4;
end
% ��������Ĵ���ͼ��?
[r, c, d] = size(detectedImg);
if d ~= 1
    % ��Ҫת��Ϊ�Ҷ�ͼ
    detectedImg = rgb2gray(detectedImg);
end
detectedImg = double(detectedImg);
if r~=options.winH && c~=options.winW
    % ��ݼ�ⴰ�ڵĴ�С������ͼ����г߶�����?����˫���Բ�ֵ)
    detectedImg = imresize(detectedImg, [options.winH options.winW],...
                           'bilinear');
end

% step 1--����1-D��־��˼���x�����y������ݶȣ���ֵ�ͷ���?
mask = [-1, 0, 1];
[grad, gradOri] = calGrad(detectedImg, mask, options.flag);

% ���block�Ĵ�С�����˹��?
sigma = min(options.blockH, options.blockW)*0.5;
sigma_2 = sigma.^2;
[X, Y] = meshgrid(0:options.blockW-1,0:options.blockH-1);
X = X - (options.blockW-1)/2;
Y = Y - (options.blockH-1)/2;
gaussWeight = exp(-(X.^2+Y.^2)/(2*sigma_2));

% ����һ����ά����������block��ֱ��ͼ
r_tmp = (options.winH-options.blockH)/options.stride+1;
c_tmp = (options.winW-options.blockW)/options.stride+1;
b_tmp = options.bins *(options.blockH*options.blockW)/...
        (options.cellH*options.cellW);
blockHist = zeros(r_tmp, c_tmp, b_tmp);

% step 2--�����ⴰ����ÿ��block��ֱ��ͼ(HOG��������)
for i=1:options.stride:(options.winH-options.blockH+1)
    for j=1:options.stride:(options.winW-options.blockW+1)
        block_grad = grad(i:i+options.blockH-1,j:j+options.blockW-1);
        block_gradOri = gradOri(i:i+options.blockH-1,j:j+options.blockW-1);
        % ���㵥��block��ֱ��ͼ��ͶƱֵΪ�ݶȷ�ֵ�͸�˹Ȩ�صĳ˻����?
        % ���й�һ������
        block_r = floor(i/options.stride)+1;
        block_c = floor(j/options.stride)+1;
        blockHist(block_r,block_c,:) = calHist(block_grad.*gaussWeight, ...
                           block_gradOri, options);
    end
end

% step 3--������block��ֱ��ͼƴ�ӳ�һά������Ϊ��ⴰ�ڵ�HOG��������
hog_Feature = reshape(blockHist, [1 numel(blockHist)]);
toc;
end



