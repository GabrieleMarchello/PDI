clear all
close all
clc

filename='***.tif';
img=mat2gray(rgb2gray(imread(filename))); 		% load image and convert into grayscale

% Local mean removal

w=128;		% window size
s=1;		% stride (pixel distance between consecutive windows)

img0=zeros(size(img));

for d=1:s:size(img,1)-w
    for c=1:s:size(img,2)-w
        
        patch=img(d:d+w,c:c+w);
        
        img0(d:d+w,c:c+w)=img(d:d+w,c:c+w)-mean(patch(:));		% mean subtraction
        
    end
end

% Gaussian filtering

gauss_s=0.25;
img_g=imgaussfilt(img0,gauss_s);

% Edge detection

img_edge=edge(img_g,'canny');

% Filling the hole may facilitate the identification (optional)

% img_fill=imfill(img_edge,'holes');

% Round objects identification

r_reg=regionprops(img_edge,'centroid','Eccentricity','BoundingBox');	
r_ecc=[r_reg.Eccentricity];

idx=find(r_ecc);
reg_def=r_reg(idx);

figure('units','normalized','outerposition',[0 0 1 1]), subplot(1,3,1), imshow(img,[])
title('Raw image')
subplot(1,3,2), imshow(img,[])
title('Bounding boxes')
hold on

ecc_toll=0.2;		% maximum difference between the main dimensions of the circular objects

p_cnt=0;

for i=1:length(idx)
    
    w=reg_def(i).BoundingBox(3);
    h=reg_def(i).BoundingBox(4);
    
    if w/h>1-ecc_toll && w/h<1+ecc_toll     % check circular profiles
        
        area=w*h;
		
        if area>120 && area<2000 && reg_def(i).Eccentricity<0.75
		
            p_cnt=p_cnt+1;
            d(p_cnt)=(w+h)/2;

            h=rectangle('Position',reg_def(i).BoundingBox,'LineWidth',2);
            set(h,'EdgeColor',[0.75 0 0]);
            hold on
			
        end
        
    end
    
end

scale_f=2.8;   % px:nm=p[px]:p[nm]    from the scale bar

d_nm=d*scale_f;		% compute the diameter in nm

pdi=(std(d_nm)/mean(d_nm))^2

subplot(1,3,3), histogram(d_nm,100)
title('Diameter distribution')
xlabel('Diameter [nm]')
ylabel('Occurrency')
text(60,12,sprintf('Number of particles: %d', p_cnt))
text(60,10,sprintf('Mean diameter: %.2f nm', mean(d_nm)))
text(60,8,sprintf('Standard dev diameter: %.2f nm', std(d_nm)))

saveas(gcf,[filename(1:end-4),'_plot.tif']);