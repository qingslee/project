file_path =  'E:\七天项目\CD\';
img_path_list = dir(strcat(file_path,'*.png'));%获取该文件夹中所有png格式的图像
img_num = length(img_path_list);
image_save=zeros(32,128,947);
if img_num > 0 %有满足条件的图像
        for j = 1:img_num %逐一读取图像
            image_name = img_path_list(j).name;% 图像名
            image =  imread(strcat(file_path,image_name));        
            
            %imagesum1=sum(image,1);%列求和
           
            %imagesum2=sum(image,2);%行求和
            %me=mean(imagesum2);
          
            %row1=find(imagesum2<me*0.85);
            %image(row1,:)=[];
            %image= imresize(image, [58 911]);
            imagesum1=sum(image,1);%列求和
           
            imagesum2=sum(image,2);%行求和
            
            col=find(imagesum1>255*60);%找出灰度值的和大于255*60的列的索引
            row=find(imagesum2>255*222);%找出灰度值的和大于255*222的行的索引
            image(:,col)=[];%去除无用的像素
            image(row,:)=[];
            if isempty(image)
                image=ones(32,128);
            end   
            image= imresize(image, [32 128]);%图片大小统一为32*128
           %level =graythresh(image);%二值化
           %image = im2bw(image,level); 
           % image_hang=sum(image,2);
           % for t=30:32
           %    if image_hang(t)<128*1/4 
           %        image(t,:)=ones(1,128);
           %    end
           %end
            image = im2double(image);
            image_save(:,:,j) = image;%将数据保存到image_save
                       
        end
end  
        