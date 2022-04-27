% For directories, ensure '/' is at the end
dir = "../../Experiment 11/";
trial = "trial 10/";
input_dir = dir + trial + "raw/";
output_dir = dir + trial + "aligned/";
extension = ".JPG";

% This is the reference image for all other images
ref_img_name = "IMG_0133";
% This is the image we are transforming to fit ref_img_name
trs_img_name = "IMG_0149";

% Read images (ref = reference, trs = the one to transform)
% Converts images to grayscale
ref_in_path = convertStringsToChars(fullfile(input_dir + "still", ref_img_name + extension));
trs_in_path = convertStringsToChars(fullfile(input_dir + "moving", trs_img_name + extension));
ref = rgb2gray(imread(ref_in_path));
trs = rgb2gray(imread(trs_in_path));

% If either mp or fp don't exist, then run cpselect
% If both mp and fp exist, prompt the user for what to do
if ~exist('mp','var') || ~exist('fp','var') || ~isempty(input('Press ENTER to skip feature selection\n>> ','s'))
    % If mp and fp exist, load them
    if exist('mp','var') && exist('fp','var') && ~isempty(mp) && ~isempty(fp)
        [mp,fp] = cpselect(trs,ref,mp,fp,'Wait',true);
    else
        [mp,fp] = cpselect(trs,ref,'Wait',true);
    end
end

% Infer geometric transformation
t = fitgeotrans(mp,fp,'nonreflectivesimilarity');

% Transform trs Image
Rfixed = imref2d(size(ref));
reg = imwarp(trs,t,'OutputView',Rfixed);

% Write to file
ref_out_path = convertStringsToChars(fullfile(output_dir + "still", ref_img_name + "_ref_nrs" + extension));
reg_out_path = convertStringsToChars(fullfile(output_dir + "moving", trs_img_name + "_reg_nrs" + extension));
imwrite(ref, ref_out_path)
imwrite(reg, reg_out_path)

imshowpair(ref,reg,'ColorChannels','red-cyan');