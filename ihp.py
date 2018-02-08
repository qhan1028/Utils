#
#   Image Histogram Processing
#   Written by Qhan
#

import numpy as np
import matplotlib.pyplot as plt
import cv2


def plotResult(bars, row, col, figsize=(8, 6)):
    plt.clf()
    f, axs = plt.subplots(row, col, figsize=figsize)
    i = 0
    if axs
    for r in range(row):
        for c in range(col):
            axs[r, c].bar(range(len(bars[i])), bars[i])
            i += 1
    plt.show()
    

## Histogram Equalization
def HE(im, plot=False):
    isRGB = len(im.shape) == 3
    
    if isRGB:
        im_yuv = cv2.cvtColor(im, cv2.COLOR_RGB2YUV)
        y = np.array(im_yuv[:, :, 0])
    else:
        y = im

    y_he = cv2.equalizeHist(y)

    if plot:
        ori_hist, _ = np.histogram(y, bins=range(256 + 1), normed=True)
        res_hist, _ = np.histogram(y_he, bins=range(256 + 1, normed=True)
        ori_cdf = np.cumsum(ori_hist)
        res_cdf = np.cumsum(res_hist)
        plotResult([ori_hist, res_hist, ori_cdf, res_cdf], 2, 2)

    if c == 3:
        return replaceY(y_he, im_yuv)
    else:
        return y_he


## Histogram Specification
def HS(original_im, target_im, plot=False):
    ori_isRGB = len(original_im.shape) == 3
    tar_isRGB = len(target_im.shape) == 3
    
    if ori_isRGB:
        ori_yuv = cv2.cvtColor(original_im, cv2.COLOR_RGB2YUV)
        ori_y = np.array(ori_yuv[:, :, 0])
    else:
        ori_y = original_im
    
    if tar_isRGB:
        tar_yuv = cv2.cvtColor(target_im, cv2.COLOR_RGB2YUV)
        tar_y = np.array(tar_yuv[:, :, 0])
    else:
        tar_y = target_im
    
    # get histogram
    ori_hist, index = np.histogram(ori_y, bins=range(256 + 1), normed=True)
    tar_hist, index = np.histogram(tar_y, bins=range(256 + 1), normed=True)
    
    # get cdf
    ori_cdf = np.cumsum(ori_hist)
    tar_cdf = np.cumsum(tar_hist)
    
    # init mapping
    mapping = np.zeros(256, dtype=np.uint8)
    
    # find mapping
    index = index[:-1]
    for i in index:
        min_diff = 1.0
        for j in range(mapping[i-1], 256):
            diff = abs(ori_cdf[i] - tar_cdf[j])
            if diff <= min_diff:
                min_diff = diff
                mapping[i] = j
            elif diff > min_diff:
                break
    
    res_y = mapping[ori_y]
    
    if plot:
        res_hist, _ = np.histogram(res_y, bins=range(256 + 1), normed=True)
        res_cdf = np.cumsum(res_hist)
        plotResult([ori_hist, tar_hist, res_hist, ori_cdf, tar_cdf, res_cdf], 2, 3)
    
    if ori_isRGB:
        return replaceY(res_y, ori_yuv)
    else:
        return res_y
