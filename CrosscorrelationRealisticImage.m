clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
%% Read in image
I = imread('C:\Users\micha\Documents\MATLAB\Image processing\Reverberation.jpg');
Igray = rgb2gray(I); %convert to grayscale
figure (1);
imshow(Igray);
%% Get template
templateWidth = 80;%set template width
templateHeight = 25; %set template height
smallSubImage = imcrop(Igray, [45, 90, templateWidth, templateHeight]);
[rows, columns] = size(smallSubImage);
figure (2);
imshow(smallSubImage);
caption = sprintf('Template Image to Search For, %d rows by %d columns.', rows, columns);
title(caption);
hold on
%% Cross Correlation output
correlationOutput = normxcorr2(smallSubImage(:,:), Igray(:,:)); %compare the template with the original image
figure (3);
imshow(correlationOutput); %show correlation image where brightest spots have highest correlation
axis on;
test = correlationOutput>0.3; %filter out least correlated parts
test1 = bwareaopen(test,200); %remove small objects
figure (4);
imshow(test1);
%% Final image
[x y]=size(test1);
for i=1:x
   for j=1:y
       if test1(i,j)==1
           Igray(i,j) = round(255 * randn());
       end
   end
end

imshow (Igray);

%% (OPTIONAL) Find out where its brightest
% Find out where the normalized cross correlation image is brightest.
[maxCorrValue, maxIndex] = max(abs(correlationOutput(:)));
[yPeak, xPeak] = ind2sub(size(correlationOutput),maxIndex(1))
% Because cross correlation increases the size of the image, 
% we need to shift back to find out where it would be in the original image.
corr_offset = [(xPeak-size(smallSubImage,2)) (yPeak-size(smallSubImage,1))]

 %% (OPTIONAL) Plot over rectangle over original image
imshow(Igray);
axis on; % Show tick marks giving pixels
hold on; % Don't allow rectangle to blow away image.
% Calculate the rectangle for the template box.  Rect = [xLeft, yTop, widthInColumns, heightInRows]
boxRect = [corr_offset(1) corr_offset(2) templateWidth, templateHeight]
% Plot the box over the image.
rectangle('position', boxRect, 'edgecolor', 'g', 'linewidth',2);


