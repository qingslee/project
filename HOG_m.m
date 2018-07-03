 for j = 1:947 %逐一读取图像
   image1= HOG(image_save(:,:,j));
   HOGfe_save(:,:,j) = image1;%将数据保存到HOGfe_save
 end