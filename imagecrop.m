clear all;
image_path = 'C:\Users\Desktop\';
image_name = 'test.jpg';
image=imread(strcat(image_path,image_name));
image = im2double(image);
[A, B, C] = size(image);

nrow = 3; 
ncolumn = 10;
scale = 0.9;

a = A/nrow;
b = B/ncolumn;
count=1;

for i = 1:nrow
    for j = 1:ncolumn 
        cropping = imcrop(image,[(j-0.5-0.5*scale)*a (i-0.5-0.5*scale)*b a*scale b*scale]);
        filename = strcat(num2str(count),'.tif');
        im_pathfile=fullfile(image_path,filename);   
        imwrite(cropping,im_pathfile);
        count = count+1
    end
end
