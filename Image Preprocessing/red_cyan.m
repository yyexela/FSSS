% For directories, ensure '/' is at the end
%input_dir = "Outdoor_old/";
input_dir_1 = "../Experiment Images/Cropped/";
input_dir_2 = "../Experiment Images/Cropped/";
extension = ".png";

% This is the reference image for all other images
%still_img = "StillEdit";
img_1 = "water_drop_still_naligned";
% This is the image we are transforming to fit still_img
%moving_img = "MovingEdit";
img_2 = "water_drop_moving_naligned";

img_1_mat = imread(input_dir_1 + img_1 + extension);
img_2_mat = imread(input_dir_2 + img_2 + extension);

imshowpair(img_1_mat,img_2_mat,'ColorChannels','red-cyan');