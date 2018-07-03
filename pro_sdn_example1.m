
        
        for m = 1:947
           % I1 = image_save(:,:,m);
           % SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
            image_lbp(:,:) = HOGfe_save(:,:,m);
            img_lbp(m,:) = image_lbp(:);
        end
        s = 1:947;
        sigma_d=0.4;
        sigma_d=1/(sigma_d*sigma_d);
        for n = 1:474
            img_lbp_shift = circshift(img_lbp,[-n 0]);
            img_lbp_sum = sum(abs(img_lbp_shift - img_lbp),2) ;
            img_lbp_sum=img_lbp_sum./sqrt(img_lbp_sum'*img_lbp_sum);
            cluster_samples((n - 1)*947+1:n*947,1) = s;
            cluster_samples((n - 1)*947+1:n*947,2) = circshift(s,[0 -n]);
            cluster_samples((n - 1)*947+1:n*947,3) =sqrt(exp(sigma_d*(img_lbp_sum.*img_lbp_sum)));
        end
        save cluster_samples cluster_samples;
            %if(j <= 5)
                %figure
                %mapping=getmapping(8,'u2');
                %H1=lbp(I1,1,8,mapping,'h');
                %subplot(2,2,1),stem(H1);
                %H2=lbp(I1);
                %subplot(2,2,2),stem(H2);
            %end


%%%%%%%%%%%%%%%%%%%%%%%%%%֮������cluster����%%%%%%%%%%%%%%%%%%%%%%
