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
parser.add_argument('--dataset_path', type=str, required=True,)

# Parse the command line arguments
args = parser.parse_args()

video = args.video
dataset_path = args.dataset_path

video_path = f'{dataset_path}/{video}/frames/'
example_dir = f'{dataset_path}/{video}/example/'
scans_dir = f'{dataset_path}/{video}/scans/'
os.makedirs(example_dir, exist_ok=True)

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

example_frame_name = frame_names[len(frame_names)//2]
example_frame_folder = f'{scans_dir}/{example_frame_name}'
os.system(f'cp -r {example_frame_folder}/* {example_dir}')