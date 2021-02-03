load Butterfly_HOG.mat;

datase_path = 'C:\Users\Desktop\new_data';
% Set datase path


% The following parameters need to be consistent with the classifier training step
Feature_Descriptors = 'HOG';
% Set feature descriptors ('HOG+LBP' or 'HOG')

imagesize = [256,256];
% Set parameter for image resizing (butterfly: 256, spider: 512)

HOG_CellSize = [32 32];
NumBins = 9;
% Set HOG parameters

LBP_CellSize = [64 64];
Normalization = 'L2';
Radius = 1;
NumNeighbors = 8;
Upright = true;
% Set LBP parameters





dataset_prediction = imageDatastore(datase_path,...  
    'IncludeSubfolders',true,...
    'FileExtensions','.tif',...  
    'LabelSource','foldernames'); 
% Read data to predict

num_prediction = length(dataset_prediction.Files);  
for i = 1:num_prediction  
    figure;
    image_prediction = readimage(dataset_prediction,i);  
    imshow(image_prediction);
    
    image_prediction = imresize(image_prediction,imagesize);  

    HOG_features = extractHOGFeatures(image_prediction,'CellSize',HOG_CellSize,'NumBins',NumBins);  
    LBP_features = extractLBPFeatures(image_prediction,'CellSize',LBP_CellSize,'Normalization',Normalization,'Radius',Radius,'NumNeighbors',NumNeighbors,'Upright',Upright);
    % (butterfly: HOG, spider: HOG+LBP)
    
    if strcmp(Feature_Descriptors,'HOG+LBP')
        Features_prediction = [HOG_features LBP_features];
        % Combine HOG and LBP feature vectors
    else if strcmp(Feature_Descriptors,'HOG')
        Features_prediction = [HOG_features];
        end
    end 

    Label_prediction = predict(classifier,Features_prediction);
    % Predict label of test sample using the trained SVM classifier

    dim = [0.4 0.88 0.25 0.05];
    str = ['Predicted Label：' char(Label_prediction)];
    annotation('textbox', dim, 'string', str, 'FitBoxToText','on',...
        'fontsize', 30, 'color', 'red','edgecolor', 'none');  
end  
