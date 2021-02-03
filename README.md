# SVMorph
SVMorph is a machine learning-based pipeline to classify complex morphological characters in non-model organisms, which is developed in the Matlab environment. The overall workflow of SVMorph includes data preprocessing, data augmentation, feature extraction, and classification. SVMorph integrates two feature descriptors, Histogram of Oriented Gradient (HOG) and Local Binary Pattern (LBP), to meet various classification needs.

We offered two usage examples (dead-leaf butterfly and jumping spider) for the pipeline.

## Requirements
SVMorph requires Matlab (version ≥ 2016b) environment. Installations of [Computer Vision Toolbox](https://www.mathworks.com/products/computer-vision.html) and [Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html) are also required.
## Usage

* Preprocessing 

  SVMorph requires all input image data transformed into eight-bit grayscale format. The rgb2gray.m script transforms image format from RGB to grayscale. The imagecrop.m script helps to crop a total image into separate images.

* Data augmentation

  The augmentation.m script enlarges training datasets with several augmentation methods including image flipping, cropping, noise addition, contrast adjustment, and image filtering. By default, the augmentation.m script will read all images of “.tif” format in a provided path and output augmented images in “.jpg” format.

* Classifier training

  The SVMorph.m script integrates feature extraction, classifier training and testing. For data input, each image of different classes should be placed into the corresponding subfolder named after its category label. For feature extraction, we provided two selections for feature descriptors, “HOG” (recommended for the butterfly dataset) and “HOG+LBP” (recommended for the spider dataset). The parameters of HOG, LBP and image resizing can be set respectively. Whether to apply data augmentation or not and the methods of data augmentation can be adjusted as well (if not, the augmented images generated from the “Data augmentation” process will not be considered as training samples).

  After running, the program will produce a trained classifier with prescribed name in “.mat” format. In addition, the confusion matrix and accuracy of each round 10-fold cross-validation, the overall confusion matrix and overall accuracy, and the dimension of the feature vector will be presented as well.

* Prediction

  The prediction.m script can output predicted labels of new image data with a trained and tested classifier. The parameters of HOG, LBP and image resizing need to be consistent with the classifier training step.
