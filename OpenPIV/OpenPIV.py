###############################################################################################################
# IMPORTS # IMPORTS # IMPORTS # IMPORTS # IMPORTS # IMPORTS # IMPORTS # IMPORTS # IMPORTS # IMPORTS # IMPORTS #
###############################################################################################################

from openpiv import tools, pyprocess, validation, filters, scaling 
import numpy as np
import matplotlib.pyplot as plt
import shutil
import os
from Functions import *

###############################################################################################################
#   PARAMETERS  # PARAMETERS # PARAMETERS # PARAMETERS # PARAMETERS # PARAMETERS # PARAMETERS #  PARAMETERS   #
###############################################################################################################

prints = False # Show print statements?

## Displacement Field
df_winsize = 24 # pixels, interrogation window size in frame A #32
df_searchsize = df_winsize # pixels, search in image B #38
df_overlap = df_winsize//2 # pixels, 50% overlap #12 (smaller than df_searchsize)(larger seems to be better)
df_dt = 1 # sec, time interval between pulses
df_sig2noise_method = 'peak2peak' # None, 'peak2peak', 'peak2mean'
df_normalized_correlation = False

## Replace Outliers
replace_outliers_method = 'localmean' # 'localmean', 'disk', 'distance'
iterative = 0 # [0] keep NaN [1] iteratively replace outliers until no NaN [2] set NaN to set_num
set_num = 0
user_thresh = 1 # Threshold for removing noisy vectors

## Scaling
pixels_per_mm = 17.3322

for trial_num in [8]:

    trial = str(trial_num)
    
    ## File Management
    output_dir = './trial ' + trial + "/"
    top_dir = "../../Experiment 12/trial " + trial + "/cropped/"
    still_path = top_dir + "still/"
    moving_path = top_dir + "moving/"

    for second in [14]:
        still_name =  str(second)
        moving_name = str(second)
        extension = '.JPG'
        still = still_path + still_name + extension
        moving = moving_path + moving_name + extension

        ## Showing Vector Field
        show_vector_field = False

        ###############################################################################################################
        #   PROCESSING  # PROCESSING # PROCESSING # PROCESSING # PROCESSING # PROCESSING # PROCESSING #  PROCESSING   #
        ###############################################################################################################

        ## Read image
        frame_a  = tools.imread( still )
        frame_b  = tools.imread( moving )

        # Run PIV
        u0, v0, sig2noise = pyprocess.extended_search_area_piv(frame_a.astype(np.int32), 
                                                            frame_b.astype(np.int32), 
                                                            window_size=df_winsize, 
                                                            overlap=df_overlap, 
                                                            dt=df_dt, 
                                                            search_area_size=df_searchsize, 
                                                            sig2noise_method=df_sig2noise_method,
                                                            normalized_correlation=df_normalized_correlation)

        x0, y0 = pyprocess.get_coordinates( image_size=frame_a.shape, 
                                        search_area_size=df_searchsize, 
                                        overlap=df_overlap )

        # Remove elements where signal to noise is more than 3, which it never is with real data
        sig2noisenew = np.delete(sig2noise.flatten(), np.where(sig2noise > 3), axis=0)

        # Keep all noisy vectors
        if df_sig2noise_method == None:
            user_thresh = 0

        if prints:
            print("user_thresh is {0}".format(user_thresh))

        # Remove noisy vectors below user_thresh
        u1, v1, mask1 = validation.sig2noise_val( u0.copy(), v0.copy(), 
                                                    sig2noise, 
                                                    threshold = user_thresh )

        if prints:
            print_changes(u0,u1, "u0,v0 -> u1,v1")

        # filter out outliers that are very different from their neighbours

        # Run first pass of replace_outliers
        u2, v2 = filters.replace_outliers( u1.copy(), v1.copy(), 
                                            method=replace_outliers_method, 
                                            max_iter=1, 
                                            kernel_size=3)

        if prints:
            print_changes(u1,u2, "u1,v1 -> u2,v2")

        # [0] keep NaN [1] iteratively replace outliers until no NaN [2] set NaN to set_num
        if iterative == 1:
            # Allow for iterative replace_outliers until there are no more NaN vectors
            u2_nan_per = 1
            u2 = u1.copy()
            v2 = v1.copy()

            while(u2_nan_per != 0):
                # CHECK if needed
                u2, v2 = filters.replace_outliers( u2.copy(), v2.copy(), 
                                                method=replace_outliers_method, 
                                                max_iter=1, 
                                                kernel_size=3)

                if prints:
                    u2_nan_per = print_changes(u1,u2, "u1,v1 -> u2,v2")
        elif iterative == 2:
            u2, v2 = filters.replace_outliers( u1.copy(), v1.copy(), 
                                            method=replace_outliers_method, 
                                            max_iter=1, 
                                            kernel_size=3)
            
            # Replace all nan with 0
            u2 = set_nan_zero(u2)
            v2 = set_nan_zero(v2)
            
            if prints:
                u2_nan_per = print_changes(u1,u2, "u1,v1 -> u2,v2")

        # 0,0 shall be bottom left, positive rotation rate is counterclockwise
        x1, y1, u3, v3 = tools.transform_coordinates(x0.copy(), y0.copy(), u2.copy(), v2.copy())

        x2, y2, u4, v4 = scaling.uniform(x1.copy(), y1.copy(), u3.copy(), v3.copy(), 
                                    scaling_factor = pixels_per_mm ) # pixels/mm (converts pixel coordinates to mm coordinates)

        # Make sure sub-directory for the trial exists
        try: 
            os.mkdir('./' + output_dir) 
        except OSError as error: 
            if prints:
                print(error)

        # Save in the simple ASCII table format
        save_filename = './' + output_dir + 's' + still_name + '_m' + moving_name + '.txt'
        tools.save(x2, y2, u4, v4, mask1, save_filename)

        # Prepend metadata about what parameters were used
        infile = open(save_filename,'r+')
        content = infile.readlines() #reads line by line and out puts a list of each line
        content[0] = '#df_winsize: ' + str(df_winsize) + '\n#df_searchsize: ' + str(df_searchsize) +\
                    '\n#df_overlap: ' + str(df_overlap) + '\n#df_dt: ' + str(df_dt) + '\n#df_sig2noise_method: ' + str(df_sig2noise_method) +\
                    '\n#df_normalized_correlation: ' + str(df_normalized_correlation) +\
                    '\n#replace_outliers_method: ' + str(replace_outliers_method) + '\n#pixels_per_mm: ' + str(pixels_per_mm) +\
                    '\n#still_img: ' + str(still) + '\n#moving_img: ' + str(moving) +\
                    '\n#iterative: ' + str(iterative) +\
                    '\n#set_num: ' + str(set_num) +\
                    '\n#user_thresh: ' + str(user_thresh) + '\n#x y u v mask\n' #replaces content of the 2nd line (index 1)

        infile.seek(0)
        infile.writelines(content)
        infile.close()

        # Copy file to fsss.txt
        shutil.copy(save_filename, './fsss.txt')

        print("Saved to", save_filename)
