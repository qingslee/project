file_path =  'E:\������Ŀ\CD\';
img_path_list = dir(strcat(file_path,'*.png'));%��ȡ���ļ���������png��ʽ��ͼ��
img_num = length(img_path_list);
image_save=zeros(32,128,947);
if img_num > 0 %������������ͼ��
        for j = 1:img_num %��һ��ȡͼ��
            image_name = img_path_list(j).name;% ͼ����
            image =  imread(strcat(file_path,image_name));        
            
            %imagesum1=sum(image,1);%�����
           
            %imagesum2=sum(image,2);%�����
            %me=mean(imagesum2);
          
            %row1=find(imagesum2<me*0.85);
            %image(row1,:)=[];
            %image= imresize(image, [58 911]);
            imagesum1=sum(image,1);%�����
           
            imagesum2=sum(image,2);%�����
            
            col=find(imagesum1>255*60);%�ҳ��Ҷ�ֵ�ĺʹ���255*60���е�����
            row=find(imagesum2>255*222);%�ҳ��Ҷ�ֵ�ĺʹ���255*222���е�����
            image(:,col)=[];%ȥ�����õ�����
            image(row,:)=[];
            if isempty(image)
                image=ones(32,128);
            end   
            image= imresize(image, [32 128]);%ͼƬ��СͳһΪ32*128
           %level =graythresh(image);%��ֵ��
           %image = im2bw(image,level); 
           % image_hang=sum(image,2);
           % for t=30:32
           %    if image_hang(t)<128*1/4 
           %        image(t,:)=ones(1,128);
           %    end
           %end
            image = im2double(image);
            image_save(:,:,j) = image;%�����ݱ��浽image_save
                       
        end
end  
        