import glob
import os
import argparse
import glob
import os

# Specify the path to the .npy file
# Create an argument parser
parser = argparse.ArgumentParser(description='Process video files.')

# Add a flag argument for videos
parser.add_argument('--video', type=str, required=True,)

# Parse the command line arguments
args = parser.parse_args()

video = args.video

video_path = f'../dynerf/{video}/frames/'
cam_poses_dir = f'../dynerf/{video}/cams/'
scans_dir = f'../dynerf/{video}/scans/'
os.makedirs(scans_dir, exist_ok=True)

# Get the list of cam*.mp4 files in the directory
frame_folders = glob.glob(f'{video_path}/cam*')
# Get the number of cam*.mp4 files
num_folders = len(frame_folders)
print(f"Number of cam* folders in {video_path}: {num_folders}")

frame_folders.sort(key=lambda x: int(x.split('/')[-1][-2:]))
# print(frame_folders)

frame_names = glob.glob(f'{frame_folders[0]}/*.jpg')
frame_names = [frame.split('/')[-1].split('.')[0] for frame in frame_names]
frame_names.sort(key=lambda x: int(x[-4:]))
# print(frame_names)
num_frames = len(frame_names)

for i in range(num_frames):
    os.makedirs(f'{scans_dir}/{frame_names[i]}', exist_ok=True)
    images_folder = f'{scans_dir}/{frame_names[i]}/images'
    os.makedirs(images_folder, exist_ok=True)
    os.system(f'cp -r {cam_poses_dir} {scans_dir}/{frame_names[i]}')
    
    for j in range(num_folders):
        frame_folder = frame_folders[j]
        frame_name = frame_names[i]
        frame_file = f'{frame_folder}/{frame_name}.jpg'
        new_frame_file = f'{images_folder}/{frame_name}.jpg'
        os.system(f'cp {frame_file} {new_frame_file}')