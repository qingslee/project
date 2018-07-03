% =========================================================================
function hist = calHist(block_grad, block_gradOri, options)
% -------------------------------------------------------------------------
% 计算单个block的直方图(它由多个cell直方图拼接而成)，并归一化处理
% block_grad-- block区域对应的梯度幅值矩阵
% block_gradOri-- block区域对应的梯度方向矩阵
% options-- 参数结构体，可以得到block中有多少个cell
% -------------------------------------------------------------------------
bins = options.bins;
cellH = options.cellH; cellW = options.cellW;
blockH = options.blockH; blockW = options.blockW;
assert(mod(blockH,cellH)==0&&mod(blockW,cellW)==0);
hist = zeros(blockH/cellH, blockW/cellW, bins);
% 每个bin对应的角度大小（如果bins为9，每个bin为20度）
if options.flag == 0
    anglePerBin = pi/bins; 
    correctVar = pi; % 用来修正currOri为负的情况
else
    anglePerBin = 2*pi/bins;
    correctVar = 2*pi;
end
halfAngle = anglePerBin/2; % 后面要用到先计算出来
for i = 1:blockH
    for j=1:blockW
        % 计算当前位置(i,j)属于的单元
        cell_r = floor((i-1)/cellH)+1;
        cell_c = floor((j-1)/cellW)+1;
        
        % 计算当前像素点相连的两个bin并投票
        currOri = block_gradOri(i,j) - halfAngle;
        % 为了将第一个bin和最后一个bin连接起来，视0度和180度等价
        if currOri <= 0
            currOri = currOri + correctVar;
        end
        % 计算该像素点梯度方向所属的两个相连bin的下标
        pre_idxOfbin = floor(currOri/anglePerBin) + 1;
        pro_idxOfbin = mod(pre_idxOfbin,bins) + 1;
        % 向相邻的两个bins进行投票(到中心点的距离作为权重)
        center = (2*pre_idxOfbin-1)*halfAngle;
        dist_w = (currOri + halfAngle-center)/anglePerBin;
        hist(cell_r,cell_c,pre_idxOfbin) = hist(cell_r,cell_c,pre_idxOfbin)...
                                           + (1-dist_w)*block_grad(i,j);
        hist(cell_r,cell_c,pro_idxOfbin) = hist(cell_r,cell_c,pro_idxOfbin)...
                                           + dist_w*block_grad(i,j);
    end
end
% 将每个cell的直方图合并（拼接一维向量）
hist = reshape(hist, [1 numel(hist)]);
% 归一化处理（默认选择L2-norm，可以用其他规则替代）
hist = hist./sqrt(hist*hist'+ options.epsilon.^2);
end
% ======================================================================
