% =========================================================================
function hist = calHist(block_grad, block_gradOri, options)
% -------------------------------------------------------------------------
% ���㵥��block��ֱ��ͼ(���ɶ��cellֱ��ͼƴ�Ӷ���)������һ������
% block_grad-- block�����Ӧ���ݶȷ�ֵ����
% block_gradOri-- block�����Ӧ���ݶȷ������
% options-- �����ṹ�壬���Եõ�block���ж��ٸ�cell
% -------------------------------------------------------------------------
bins = options.bins;
cellH = options.cellH; cellW = options.cellW;
blockH = options.blockH; blockW = options.blockW;
assert(mod(blockH,cellH)==0&&mod(blockW,cellW)==0);
hist = zeros(blockH/cellH, blockW/cellW, bins);
% ÿ��bin��Ӧ�ĽǶȴ�С�����binsΪ9��ÿ��binΪ20�ȣ�
if options.flag == 0
    anglePerBin = pi/bins; 
    correctVar = pi; % ��������currOriΪ�������
else
    anglePerBin = 2*pi/bins;
    correctVar = 2*pi;
end
halfAngle = anglePerBin/2; % ����Ҫ�õ��ȼ������
for i = 1:blockH
    for j=1:blockW
        % ���㵱ǰλ��(i,j)���ڵĵ�Ԫ
        cell_r = floor((i-1)/cellH)+1;
        cell_c = floor((j-1)/cellW)+1;
        
        % ���㵱ǰ���ص�����������bin��ͶƱ
        currOri = block_gradOri(i,j) - halfAngle;
        % Ϊ�˽���һ��bin�����һ��bin������������0�Ⱥ�180�ȵȼ�
        if currOri <= 0
            currOri = currOri + correctVar;
        end
        % ��������ص��ݶȷ�����������������bin���±�
        pre_idxOfbin = floor(currOri/anglePerBin) + 1;
        pro_idxOfbin = mod(pre_idxOfbin,bins) + 1;
        % �����ڵ�����bins����ͶƱ(�����ĵ�ľ�����ΪȨ��)
        center = (2*pre_idxOfbin-1)*halfAngle;
        dist_w = (currOri + halfAngle-center)/anglePerBin;
        hist(cell_r,cell_c,pre_idxOfbin) = hist(cell_r,cell_c,pre_idxOfbin)...
                                           + (1-dist_w)*block_grad(i,j);
        hist(cell_r,cell_c,pro_idxOfbin) = hist(cell_r,cell_c,pro_idxOfbin)...
                                           + dist_w*block_grad(i,j);
    end
end
% ��ÿ��cell��ֱ��ͼ�ϲ���ƴ��һά������
hist = reshape(hist, [1 numel(hist)]);
% ��һ������Ĭ��ѡ��L2-norm���������������������
hist = hist./sqrt(hist*hist'+ options.epsilon.^2);
end
% ======================================================================
