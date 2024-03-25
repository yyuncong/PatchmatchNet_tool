from datasets.data_io import read_pfm
from PIL import Image
import numpy as np

path = 'depth_est/00000005.pfm'
data, scale = read_pfm(path)

min_depth, max_depth = np.percentile(data, 5), np.percentile(data, 95)
data[data > max_depth] = max_depth

data = (data - np.min(data)) / (np.max(data) - np.min(data))
data = np.uint8(data * 255)
img = Image.fromarray(data.squeeze())
img.save('visualize_depth.jpg')
