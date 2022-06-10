import numpy as np

def get_nan_num(arr):
    num = 0
    for i in range(0,len(arr)):
        for j in range(0,len(arr[0])):
            val = arr[i][j]
            if np.isnan(val):
                num = num + 1
    return num

# Replace all nan with 0
def set_nan_zero(arr):
    arr_new = arr.copy()
    for i in range(0,len(arr_new)):
        for j in range(0,len(arr_new[0])):
            val = arr_new[i][j]
            if np.isnan(val):
                arr_new[i][j] = 0
    return arr_new

# Print change in NaN from array 1 to array 2
# Returns u2_nan_per
def print_changes(arr1, arr2, str):
    # Calculate changes is nan (same values for u2 and v2)
    total_num = (len(arr1)*len(arr1[0]))
    u1_nan_num = get_nan_num(arr1)
    u1_nan_per = 100*u1_nan_num/total_num
    u2_nan_num = get_nan_num(arr2)
    u2_nan_per = 100*u2_nan_num/total_num
    u2_nan_change_num = u2_nan_num - u1_nan_num
    u2_nan_change_per = (u2_nan_num - u1_nan_num)/total_num*100
    print(str)
    print("{0: <12s}: {1}/{2} ({3: <.2f}%)".format("old nan_num",u1_nan_num,total_num,u1_nan_per))
    print("{0: <12s}: {1}/{2} ({3: <.2f}%)".format("new nan_num",u2_nan_num,total_num,u2_nan_per))
    print("{0: <12s}: {1} ({2: <.2f})%".format("nan change",u2_nan_change_num,u2_nan_change_per))
    return u2_nan_per

