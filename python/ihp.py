#
#   Image Histogram Processing
#   Written by Qhan
#

import numpy as np
import matplotlib.pyplot as plt
import cv2


def replaceY(y, im_yuv):
    im_yuv[:, :, 0] = y
    return cv2.cvtColor(im_yuv, cv2.COLOR_YUV2RGB)


def preprocess(im):
    isRGB = len(im.shape) == 3
    if isRGB:
        im_yuv = cv2.cvtColor(im, cv2.COLOR_RGB2YUV)
        return np.array(im_yuv[:, :, 0]), im_yuv
    else:
        return im, None


def postprocess(y, im_yuv):
    if im_yuv is None:
        return y
    else:
        return replaceY(y, ori_yuv)


def plotResult(bars, row, col, figsize=(8, 6)):
    plt.clf()
    f, axs = plt.subplots(row, col, figsize=figsize)
    if len(bars) > 1:
        i = 0
        for r in range(row):
            for c in range(col):
                axs[r, c].bar(range(len(bars[i])), bars[i])
                i += 1
    else:
        axs.bar(range(len(bars[0])), bars[0])

    plt.show()
    

## Histogram Equalization
def HE(im, plot=False):
    y, im_yuv = preprocess(im)

    y_he = cv2.equalizeHist(y)

    if plot:
        ori_hist, _ = np.histogram(y, bins=range(256 + 1), normed=True)
        res_hist, _ = np.histogram(y_he, bins=range(256 + 1), normed=True)
        ori_cdf = np.cumsum(ori_hist)
        res_cdf = np.cumsum(res_hist)
        plotResult([ori_hist, res_hist, ori_cdf, res_cdf], 2, 2)

    return postprocess(y_he, im_yuv)


## Histogram Specification
def HS(original_im, target_im, plot=False):
    ori_y, ori_yuv = preprocess(original_im)
    tar_y, tar_yuv = preprocess(target_im)
    
    # get histogram, cdf
    ori_hist, index = np.histogram(ori_y, bins=range(256 + 1), normed=True)
    tar_hist, index = np.histogram(tar_y, bins=range(256 + 1), normed=True)
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
    
    return postprocess(res_y, ori_yuv)


## Mean Matching
def MM(original_im, target_im):
    ori_y, ori_yuv = preprocess(original_im)
    tar_y, tar_yuv = preprocess(target_im)

    diff = int(round(np.mean(tar_y) - np.mean(ori_y)))
    res_y = np.clip(ori_y.astype(np.int) + diff, 0, 255).astype(np.uint8)

    return postprocess(res_y, ori_yuv)
