%{
Ok we're gonna try this again
No stress this time, it's easy peasy
Gonna make it nice and fast
Lots of classifications
%}

%This is the filename of the folders
% digitDatasetPath = 'C:\Users\Peter\OneDrive - University of Bath\Desktop\Airglow Bits\Codey Bits\anotherMachineFolder\millstone\millTrain';
% digitDatasetPath = fullfile(pwd, 'trainmore')
digitDatasetPath = '/data2/peter/alloverairglow/machinelearning/CNN/trainmore';

%This puts the images into here classified as the folder names
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
%This splits the files into training and validation
% numTrainFiles = 750;
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.8,'randomized');

inputSize = [301 301 1];
numClasses = 8;

layers = [
    imageInputLayer(inputSize)
    convolution2dLayer(5,20)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    dropoutLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

% opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 20, 'MiniBatchSize', 64);

options = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MiniBatchSize', 64,...
    'MaxEpochs',20, ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress', ...
    'ExecutionEnvironment', 'cpu');

imageAugmenter = imageDataAugmenter('RandXReflection',1, 'RandYReflection',1);
augimds = augmentedImageDatastore(inputSize, imdsTrain, 'DataAugmentation', imageAugmenter);
net = trainNetwork(augimds,layers,options);

YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;
accuracy = mean(YPred == YValidation)

save net
