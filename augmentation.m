clear all;
path=genpath('C:\Users\Desktop\dead-leaf butterfly'); 
% Generate a path name that includes all the folders and subfolders

length_path=size(path,2);
filepath={};
temp=[];
for i=1:length_path 
    if path(i)~=';'
        temp=[temp path(i)];
        else
        temp=[temp '\'];
        filepath=[filepath;temp];
        temp=[];
    end
end

folder_num=size(filepath,1); 
% Get the number of folders and subfolders

for i=1:folder_num
    image_path = filepath{i};
    image_path_list=dir(strcat(image_path,'*.tif')); 
    % List all image files in the current subfolder
    image_num=length(image_path_list);
    % Get the number all image files in the current subfolder
    if image_num > 0
        for j=1:image_num
            image_name=image_path_list(j).name;
            image=imread(strcat(image_path,image_name));
            fprintf('%d %d %s\n',i,j,strcat(image_path,image_name));
            % Print the name and order of the current image
            
            [L W] = size(image);

            flipping = fliplr(image);% flipping
            filename = strcat(image_name,'-flp.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(flipping,im_pathfile);

            adj1a = unifrnd (0,0.1);
            adj1b = unifrnd (0.9,1);
            adj1 = imadjust(image, [adj1a,adj1b], []);% contrast adjustment with random parameter 1
            filename = strcat(image_name,'-adj1.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(adj1,im_pathfile);
            
            adj2a = unifrnd (0,0.1);
            adj2b = unifrnd (0.9,1);
            adj2 = imadjust(image, [adj2a,adj2b], []);% contrast adjustment with random parameter 2
            filename = strcat(image_name,'-adj2.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(adj2,im_pathfile);

            noise1a = unifrnd (0.1,0.2);
            noise1b = unifrnd (0.02,0.05);
            noise1 = imnoise(image,'gaussian',noise1a,noise1b);% Gaussian white noise addition with random parameter 1
            filename = strcat(image_name,'-noise1.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(noise1,im_pathfile);
            
            noise2a = unifrnd (0.1,0.2);
            noise2b = unifrnd (0.02,0.05);
            noise2 = imnoise(image,'gaussian',noise2a,noise2b);% Gaussian white noise addition with random parameter 2
            filename = strcat(image_name,'-noise2.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(noise2,im_pathfile);
            
            cropping1a = unifrnd (0,L*0.125);
            cropping1b = unifrnd (0,L*0.125);     
            cropping1 = imcrop(image,[cropping1a cropping1b L*0.875 L*0.875]);% random cropping 1
            filename = strcat(image_name,'-crp1.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(cropping1,im_pathfile);
            
            cropping2a = unifrnd (0,L*0.125);
            cropping2b = unifrnd (0,L*0.125);      
            cropping2 = imcrop(image,[cropping2a cropping2b L*0.875 L*0.875]);% random cropping 2
            filename = strcat(image_name,'-crp2.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(cropping2,im_pathfile);
            
            cropping3a = unifrnd (0,L*0.125);
            cropping3b = unifrnd (0,L*0.125);      
            cropping3 = imcrop(image,[cropping3a cropping3b L*0.875 L*0.875]);% random cropping 3 
            filename = strcat(image_name,'-crp3.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(cropping3,im_pathfile);
            
            cropping4a = unifrnd (0,L*0.125);
            cropping4b = unifrnd (0,L*0.125);      
            cropping4 = imcrop(image,[cropping4a cropping4b L*0.875 L*0.875]);% random cropping 4 
            filename = strcat(image_name,'-crp4.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(cropping4,im_pathfile);
            
            filtering1 = imfilter(image,fspecial('average',[3 3]),'conv','replicate'); % averaging filtering
            filename = strcat(image_name,'-ftr1.jpg');
            im_pathfile=fullfile(image_path,filename);   
            imwrite(filtering1,im_pathfile);
                        
        end
    end
end
