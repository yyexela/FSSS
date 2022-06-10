skip_option = 0;

% For directories, ensure '/' is at the end
top_dir = "../../Experiment 12/";
still_dir = top_dir + "trial 1/";
trial = "11";
seconds = "10";
moving_dir = top_dir + "trial " + trial + "/";
extension = ".JPG";

% This is the reference image for all other images
ref_img_name = seconds;
% This is the image we are transforming to fit ref_img_name
trs_img_name = seconds;

% Read images (ref = reference, trs = the one to transform)
% Converts images to grayscale
ref_in_path = convertStringsToChars(fullfile(still_dir + "raw/", ref_img_name + extension));
trs_in_path = convertStringsToChars(fullfile(moving_dir + "raw/", trs_img_name + extension));
ref = rgb2gray(imread(ref_in_path));
trs = rgb2gray(imread(trs_in_path));

% If either mp or fp don't exist, then run cpselect
% If both mp and fp exist, prompt the user for what to do
if ~skip_option || ~exist('mp','var') || ~exist('fp','var') || ~isempty(input('Press ENTER to skip feature selection\n>> ','s'))
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
ref_out_path = convertStringsToChars(fullfile(still_dir + "aligned/", ref_img_name + "_ref_nrs" + extension));
reg_out_path = convertStringsToChars(fullfile(moving_dir + "aligned/", trs_img_name + "_reg_nrs" + extension));
imwrite(ref, ref_out_path)
imwrite(reg, reg_out_path)

imshowpair(ref,reg,'ColorChannels','red-cyan');

filename = seconds + "_" + trial;
save(convertStringsToChars(filename))