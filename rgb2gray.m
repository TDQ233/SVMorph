clear all;
path=genpath('C:\Users\Desktop\rgb_data'); 
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

            grayscale = rgb2gray(image);
            filename = strcat(image_name);
            im_pathfile=fullfile(image_path,filename);  
            imwrite(grayscale,im_pathfile);
        end
    end
end
