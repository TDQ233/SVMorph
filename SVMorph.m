clear all;
dataset_path = 'C:\Users\Desktop\dead-leaf butterfly';
% Set datase path

classifier_name = 'Butterfly_HOG';
% Define a name for the output classifier

Feature_Descriptors = 'HOG';
% Set feature descriptors ('HOG+LBP' or 'HOG')

Data_augmentation = true;
% Apply data augmentation or not (true or false)
Flipping = true;
Contrast = true;
Noise = true;
Cropping = true;
Filtering = false;
% Choose data augmentation methods (true or false)
% (butterfly: Flipping, Contrast, Noise, Cropping; spider: Flipping, Cropping, Filtering)

k = 10; 
% Set k-fold cross-validation  

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





dataset_ori = imageDatastore(dataset_path,...  
    'IncludeSubfolders',true,...
    'FileExtensions','.tif',...  
    'LabelSource','foldernames'); 
% Read dataset without data augmentation (only .tif format)

dataset_aug = imageDatastore(dataset_path,...  
    'IncludeSubfolders',true,...  
    'LabelSource','foldernames'); 
% Read dataset with data augmentation

name_aug = dataset_aug.Files;

D = dir(dataset_path);
num_class = 0;
for i = 1 : length(D)
    if(isequal(D(i).name, '.' ) || isequal(D(i).name, '..' ) || ~D(i).isdir )
    else
        D(i).name;
        num_class = num_class + 1;
    end
end

Accuracy_overall = 0;
Confusion_M_sum=zeros(num_class);

data_random = shuffle(dataset_ori);
% Shuffle all images for cross-validation

data_partition{k} = [];
for i = 1:k
   temp = partition(data_random, k, i);
   data_partition{i} = temp.Files;
end
order = crossvalind('Kfold', k, k);
% Partition all samples into k subsets randomly

for i = 1:k
    test_subset = (order == i);
    % For each subset, the single set is reserved as the test data
    train_subset = ~test_subset;
    % The remaining k-1 subsets are used to train the model
    
    testset = imageDatastore(data_partition{test_subset}, 'IncludeSubfolders', true,'FileExtensions','.tif', 'LabelSource', 'foldernames');
    trainingset = imageDatastore(cat(1, data_partition{train_subset}), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   
    training_name = trainingset.Files;
    training_num = length(trainingset.Files);
    
    for j = 1:training_num
        filename1 = strcat(training_name(j),'-flp.jpg');
        filename2 = strcat(training_name(j),'-adj1.jpg');
        filename3 = strcat(training_name(j),'-adj2.jpg');
        filename4 = strcat(training_name(j),'-noise1.jpg');
        filename5 = strcat(training_name(j),'-noise2.jpg');
        filename6 = strcat(training_name(j),'-crp1.jpg');
        filename7 = strcat(training_name(j),'-crp2.jpg');
        filename8 = strcat(training_name(j),'-crp3.jpg');
        filename9 = strcat(training_name(j),'-crp4.jpg');
        filename10 = strcat(training_name(j),'-ftr1.jpg');
              
        if Flipping
            training_name = [training_name;filename1];
        end
        
        if Contrast
            training_name = [training_name;filename2];
            training_name = [training_name;filename3];
        end
        
        if Noise 
            training_name = [training_name;filename4];
            training_name = [training_name;filename5];
        end
        
        if Cropping
            training_name = [training_name;filename6];
            training_name = [training_name;filename7];
            %training_name = [training_name;filename8];
            %training_name = [training_name;filename9];
        end
        
        if Filtering
            training_name = [training_name;filename10];
        end
        
    end
    % Choose data augmentation methods
    % (butterfly: flp, adj1, adj2, noise1, noise2, crp1, crp2; spider: flp, crp1, crp2, ftr1)
   
    training_aug = intersect(training_name,name_aug);
    
    if Data_augmentation
        trainingset = imageDatastore(training_aug, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
        % Use training set with data augmentation (Data_augmentation = 'true')
    else
        trainingset = imageDatastore(cat(1, data_partition{train_subset}), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
        % Use training set without data augmentation
    end
    
    image_example = readimage(trainingset,1);  
    image_example_resize = imresize(image_example,imagesize);  
    HOG_features = extractHOGFeatures(image_example_resize,'CellSize',HOG_CellSize,'NumBins',NumBins); 
    LBP_features = extractLBPFeatures(image_example_resize,'CellSize',LBP_CellSize,'Normalization',Normalization...
        ,'Radius',Radius,'NumNeighbors',NumNeighbors,'Upright',Upright);
    if strcmp(Feature_Descriptors,'HOG+LBP')
        Feature_dimension = length(HOG_features) + length(LBP_features);
    else if strcmp(Feature_Descriptors,'HOG')
        Feature_dimension = length(HOG_features);
        end
    end
    % Calculate dimensions of feature vectors
    % (butterfly: HOG, spider: HOG+LBP)
    
    
    num_training = length(trainingset.Files);  
    Features_training = zeros(num_training,Feature_dimension,'single');
    for j = 1:num_training  
        image_training = readimage(trainingset,j);  
        image_training = imresize(image_training,imagesize);  
        HOG_features = extractHOGFeatures(image_training,'CellSize',HOG_CellSize,'NumBins',NumBins);  
        LBP_features = extractLBPFeatures(image_training,'CellSize',LBP_CellSize,'Normalization',Normalization...
            ,'Radius',Radius,'NumNeighbors',NumNeighbors,'Upright',Upright);      
        if strcmp(Feature_Descriptors,'HOG+LBP')
            Features_training(j, :) = [HOG_features LBP_features];
            % Combine HOG and LBP feature vectors
        else if strcmp(Feature_Descriptors,'HOG')
            Features_training(j, :) = [HOG_features];
            end
        end
    end
    % Extract features for training samples
    
    labels_training = trainingset.Labels; 
    % Get labels of training samples
 
    t = templateSVM('Standardize',true,'KernelFunction','linear');
    % SVM model with linear kernel function
    classifier = fitcecoc(Features_training,labels_training,'Learners',t);
    % Train an SVM classifier using one-versus-one coding design
    save(classifier_name, 'classifier');

    
    
    num_test = length(testset.Files);  
    Features_test = zeros(num_test,Feature_dimension,'single');
    for j = 1:num_test  
        image_test = readimage(testset,j);  
        image_test = imresize(image_test,imagesize);  
        HOG_features = extractHOGFeatures(image_test,'CellSize',HOG_CellSize,'NumBins',NumBins);  
        LBP_features = extractLBPFeatures(image_test,'CellSize',LBP_CellSize,'Normalization',Normalization...
            ,'Radius',Radius,'NumNeighbors',NumNeighbors,'Upright',Upright);   
        if strcmp(Feature_Descriptors,'HOG+LBP')
            Features_test(j, :) = [HOG_features LBP_features];
            % Combine HOG and LBP feature vectors
        else if strcmp(Feature_Descriptors,'HOG')
            Features_test(j, :) = [HOG_features];
            end
        end 
    end
    % Extract features for test samples
    
    labels_test = testset.Labels;
    % Get labels of test samples
    
    labels_predicted = predict(classifier,Features_test);
    % Classify test samples using the trained SVM classifier
    
   
    Confusion_M = confusionmat(labels_test, labels_predicted, 'order',unique(labels_training))
    % Compute and print confusion matrix
    % The'order' argument prevents dislocation caused by zero sample size
    Confusion_M_sum = Confusion_M_sum + Confusion_M;
    Accuracy = sum(diag(Confusion_M))/sum(Confusion_M(:))
    % Calculate accuracy
    Accuracy_overall = Accuracy_overall + Accuracy;
end

    Accuracy_overall = Accuracy_overall/k;
    Confusion_M_sum
